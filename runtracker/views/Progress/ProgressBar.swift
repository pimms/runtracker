import UIKit
import SwiftUI

// MARK: - Bar

class Bar: UIView {
    static let barHeight: CGFloat = 5.0

    required init(color: UIColor) {
        super.init(frame: .zero)
        backgroundColor = color
        layer.cornerRadius = Bar.barHeight / 2.0

        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: Bar.barHeight)
        ])
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
}

// MARK: - ProgressBarBase

class ProgressBarBase: UIView {
    var markerFraction: CGFloat? {
        didSet {
            if markerFraction == nil {
                markerLayer.isHidden = true
            } else {
                updateMarkerLayer()
            }
        }
    }

    fileprivate lazy var backgroundBar: Bar = {
        let bar = Bar(color: UIColor.systemFill)
        bar.translatesAutoresizingMaskIntoConstraints = false
        return bar
    }()

    private lazy var markerLayer: CALayer = {
        let layer = CALayer()
        layer.backgroundColor = UIColor.systemGray.cgColor
        layer.bounds = CGRect(x: 0, y: 0, width: 2, height: Bar.barHeight + 4.0)
        layer.cornerRadius = 1.0
        return layer
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    init() {
        super.init(frame: .zero)
        setup()
    }

    private func setup() {
        addSubview(backgroundBar)
        backgroundBar.fillInSuperview()
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        if markerFraction != nil {
            updateMarkerLayer()
        }
    }

    private func updateMarkerLayer() {
        guard let fraction = markerFraction else {
            markerLayer.isHidden = true
            return
        }

        markerLayer.isHidden = false
        if markerLayer.superlayer == nil {
            layer.addSublayer(markerLayer)
        }

        let origin = backgroundBar.frame.origin
        let position = CGPoint(x: origin.x - 1.0 + fraction*backgroundBar.frame.width,
                               y: origin.y + 0.5*backgroundBar.frame.height)
        markerLayer.position = position
    }
}

// MARK: - ProgressBar

class ProgressBar: ProgressBarBase {
    var progress: Double { didSet { initializeProgressBar() } }
    private let progressColor: UIColor

    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }

    required init(progress: Double, progressColor: UIColor = .systemGreen) {
        self.progressColor = progressColor
        self.progress = progress
        super.init()
        initializeProgressBar()
    }

    private func initializeProgressBar() {
        if progress > 1 {
            markerFraction = CGFloat(1.0 / progress)
        } else {
            markerFraction = nil
        }

        let progressBar = Bar(color: progressColor)
        progressBar.translatesAutoresizingMaskIntoConstraints = false
        backgroundBar.subviews.forEach { $0.removeFromSuperview() }
        backgroundBar.addSubview(progressBar)

        let widthFraction = progress > 1 ? 1 : progress

        NSLayoutConstraint.activate([
            progressBar.leadingAnchor.constraint(equalTo: backgroundBar.leadingAnchor),
            progressBar.topAnchor.constraint(equalTo: backgroundBar.topAnchor),
            progressBar.bottomAnchor.constraint(equalTo: backgroundBar.bottomAnchor),
            progressBar.widthAnchor.constraint(equalTo: backgroundBar.widthAnchor, multiplier: CGFloat(widthFraction))
        ])
    }
}

struct SUIProgressBar: UIViewRepresentable {
    typealias UIViewType = ProgressBar

    private let color: UIColor
    private let progress: Double

    init(progress: Double, color: UIColor = .systemGreen) {
        self.color = color
        self.progress = progress
    }

    func makeUIView(context: Context) -> ProgressBar {
        ProgressBar(progress: progress, progressColor: color)
    }

    func updateUIView(_ uiView: ProgressBar, context: Context) {
        uiView.progress = progress
    }
}

#if DEBUG
struct SUIProgressBar_Previews: PreviewProvider {
    static var previews: some View {
        let list = List {
            VStack {
                HStack {
                    Text("75% filled")
                    Spacer()
                }
                SUIProgressBar(progress: 0.75)
                    .frame(height: Bar.barHeight)
            }

            VStack {
                HStack {
                    Text("200% filled")
                    Spacer()
                }
                SUIProgressBar(progress: 2)
                    .frame(height: Bar.barHeight)
            }

            VStack {
                HStack {
                    Text("0% filled")
                    Spacer()
                }
                SUIProgressBar(progress: 0)
                    .frame(height: Bar.barHeight)
            }
        }

        return VStack {
            list.colorScheme(.dark)
            list.colorScheme(.light)
        }
    }
}
#endif

// MARK: - MultiSegmentProgressBar

class MultiSegmentProgressBar: ProgressBarBase {
    var rawSegmentValues: [Double] { didSet { resetBars() } }
    var goalValue: Double? { didSet { updateGoalMarker() } }

    private var bars: [Bar] = []

    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }

    required init(rawSegmentValues: [Double], goalValue: Double?) {
        self.rawSegmentValues = rawSegmentValues
        self.goalValue = goalValue
        super.init(frame: .zero)

        updateGoalMarker()
        setupBars()
    }

    private func resetBars() {
        removeBars()
        setupBars()
    }

    private func removeBars() {
        backgroundBar.subviews.forEach { $0.removeFromSuperview() }
    }

    private func setupBars() {
        let sum = rawSegmentValues.reduce(0, +)
        let widthDenominator = max(goalValue ?? sum, sum)

        let fractionValues = rawSegmentValues.map { CGFloat($0 / widthDenominator) }
        let colors = colorArray()
        var index: Int = 0
        var trailingEdgeAnchor = backgroundBar.leadingAnchor

        for segmentFraction in fractionValues {
            let color = colors[index % colors.count]
            index += 1

            let bar = Bar(color: color)
            bar.translatesAutoresizingMaskIntoConstraints = false
            backgroundBar.addSubview(bar)

            NSLayoutConstraint.activate([
                bar.leadingAnchor.constraint(equalTo: trailingEdgeAnchor),
                bar.topAnchor.constraint(equalTo: backgroundBar.topAnchor),
                bar.bottomAnchor.constraint(equalTo: backgroundBar.bottomAnchor),
                bar.widthAnchor.constraint(equalTo: backgroundBar.widthAnchor, multiplier: segmentFraction)
            ])

            trailingEdgeAnchor = bar.trailingAnchor
        }
    }

    private func updateGoalMarker() {
        let sum = rawSegmentValues.reduce(0, +)

        if let goal = goalValue, sum > goal {
            markerFraction = CGFloat(goal / sum)
        } else {
            markerFraction = nil
        }
    }

    private func colorArray() -> [UIColor] {
        let colors: [UIColor] = [ .systemYellow, .systemBlue, .systemGreen, .systemPink ]

        let rounded = rawSegmentValues.map { Int($0) }
        let seed = rounded.reduce(0, +)
        var rng = SeedableRNG(seed: seed)

        return colors.shuffled(using: &rng)
    }
}

struct SUIMultiSegmentProgressBar: UIViewRepresentable {
    typealias UIViewType = MultiSegmentProgressBar

    private let rawSegmentValues: [Double]
    private let goalValue: Double?

    init(rawSegmentValues: [Double], goalValue: Double?) {
        self.rawSegmentValues = rawSegmentValues
        self.goalValue = goalValue
    }

    func makeUIView(context: Context) -> MultiSegmentProgressBar {
        MultiSegmentProgressBar(rawSegmentValues: rawSegmentValues, goalValue: goalValue)
    }

    func updateUIView(_ uiView: MultiSegmentProgressBar, context: Context) {
        uiView.goalValue = goalValue
        uiView.rawSegmentValues = rawSegmentValues
    }
}

#if DEBUG
struct SUIMultiSegmentProgressBar_Previews: PreviewProvider {
    static var previews: some View {
        let list = List {
            VStack {
                HStack {
                    Text("One value, 30%")
                    Spacer()
                }
                SUIMultiSegmentProgressBar(rawSegmentValues: [30], goalValue: 100)
                    .frame(height: Bar.barHeight)
            }
            VStack {
                HStack {
                    Text("Two values, 60%")
                    Spacer()
                }
                SUIMultiSegmentProgressBar(rawSegmentValues: [20, 40], goalValue: 100)
                    .frame(height: Bar.barHeight)
            }
            VStack {
                HStack {
                    Text("Three values, 150%")
                    Spacer()
                }
                SUIMultiSegmentProgressBar(rawSegmentValues: [20, 40, 90], goalValue:
                    100)
                    .frame(height: Bar.barHeight)
            }
        } 

        return VStack {
            list.colorScheme(.dark)
            list.colorScheme(.light)
        }
    }
}

struct SUIMultiSegmentProgressBarNoGoal_Previews: PreviewProvider {
    static var previews: some View {
        let list = List {
            VStack {
                HStack {
                    Text("One value, 30%")
                    Spacer()
                }
                SUIMultiSegmentProgressBar(rawSegmentValues: [30], goalValue: nil)
                    .frame(height: Bar.barHeight)
            }
            VStack {
                HStack {
                    Text("Two values, 60%")
                    Spacer()
                }
                SUIMultiSegmentProgressBar(rawSegmentValues: [20, 40], goalValue: nil)
                    .frame(height: Bar.barHeight)
            }
            VStack {
                HStack {
                    Text("Three values, 150%")
                    Spacer()
                }
                SUIMultiSegmentProgressBar(rawSegmentValues: [20, 40, 90], goalValue:
                    nil)
                    .frame(height: Bar.barHeight)
            }
        }

        return VStack {
            list.colorScheme(.dark)
            list.colorScheme(.light)
        }
    }
}
#endif
