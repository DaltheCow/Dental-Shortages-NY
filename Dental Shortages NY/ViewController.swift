import UIKit

class ViewController: UIViewController {

    let height = UIScreen.main.bounds.size.height
    let width = UIScreen.main.bounds.size.width
    var regionPaths : [(imgView: UIImageView, name: String, path: UIBezierPath)] = []
    var mapView = UIView(frame: CGRect(x: 0, y: UIApplication.shared.statusBarFrame.size.height, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height - UIApplication.shared.statusBarFrame.size.height))
    var infoView = UIView(frame: CGRect(x: 0, y: UIApplication.shared.statusBarFrame.size.height, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height - UIApplication.shared.statusBarFrame.size.height))
    var infoViewT = UIView(frame: CGRect(x: 0, y: UIApplication.shared.statusBarFrame.size.height, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height - UIApplication.shared.statusBarFrame.size.height))
    var infoViewM = UIView(frame: CGRect(x: 0, y: UIApplication.shared.statusBarFrame.size.height, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height - UIApplication.shared.statusBarFrame.size.height))
    var regionImgViews : [(imgView: UIImageView, name: String, counties: [(name: String, path: UIBezierPath, data: (countyName: String, specialPopulation: Bool, geographic: Bool, facility: Bool, nativeAmerican: Bool, dentistLicenses: String, numPeople: String, under5YO: String, gte65YO: String, white: String, africanAmerican: String, americanIndian: String, asian: String, hispOrLat: String, veterans: String, foreignBorn: String, gteHS: String, ba: String, disUnder65: String, woInsuranceUnder65: String, medIncome: String, poverty: String))])] = []
    var backButton = UIButton(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    var viewButton = UIButton(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    var regionTitle = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    var regionTitleI = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    var scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    var currentData = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    var toggle = UIButton(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    var infoButton1 = UIButton(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    var infoButton2 = UIButton(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    var resourceButton = UIButton(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    var toggleState = false
    var viewClicked : Int?
    var nyText = ""
    var currentCountyText = ""
    var windowOpen = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadViews()
    }
    
    func loadViews() {
        self.view.addSubview(mapView)
        
        let mapWidth = mapView.frame.width
        let mapHeight = mapView.frame.height
        
        let infoWidth = infoView.frame.width
        let infoHeight = infoView.frame.height
        
        infoView.backgroundColor = UIColor.gray
        
        infoViewT = UIView(frame:CGRect(x: 0, y: 0, width: infoWidth * 0.4, height: infoHeight))
        infoViewM = UIView(frame:CGRect(x: infoWidth * 0.42, y: infoHeight * 0.02, width: infoWidth * 0.56, height: infoHeight * 0.96))
        infoView.addSubview(infoViewT)
        infoView.addSubview(infoViewM)
        
        let img = UIImage(named: "ny")
        let imgView = UIImageView(image: img)
        let AR = (img?.size.width)! / (img?.size.height)!
        var size = (width: CGFloat(0), height: CGFloat(0))
        //should be using width and height from the subview's numbers, not the screen
        if (AR > mapWidth / mapHeight) {
            size = (width: CGFloat(mapWidth), height: CGFloat(mapWidth / AR))
        } else if (AR < mapWidth / mapHeight) {
            size = (width: CGFloat(mapHeight * AR), height: CGFloat(mapHeight))
        } else {
            size = (width: CGFloat(mapWidth), height: CGFloat(mapHeight))
        }
        
        let center = (x: (mapWidth - size.width) / 2, y: (mapHeight - size.height) / 2)
        imgView.frame = CGRect(x: center.x, y: center.y, width: size.width, height: size.height)
        mapView.addSubview(imgView)
        
        let sizingLabel = UILabel(frame: CGRect(x:0,y:0,width:0,height:0))
        sizingLabel.text = "Dental Shortage Areas\nin New York State"
        sizingLabel.numberOfLines = 0
        let labelHeight = sizingLabel.intrinsicContentSize.height
        
        let appTitle = UILabel(frame: CGRect(x: mapView.frame.width * 0.02, y: mapView.frame.height * 0.02, width: mapView.frame.width * 0.4, height: mapView.frame.height * 0.18))
        appTitle.text = "Dental Shortage Areas\nin New York State"
        appTitle.numberOfLines = 0
        let fontSize = mapView.frame.height > mapView.frame.width ? mapView.frame.width : mapView.frame.height
        appTitle.font = regionTitleI.font.withSize(fontSize * 0.1)
        appTitle.adjustsFontSizeToFitWidth = true
        
        mapView.addSubview(appTitle)
        
        
        
        var backButtonWidth = infoWidth / 15
        var backButtonHeight = infoHeight / 15
        let bRatio = backButtonWidth / backButtonHeight
        if (backButtonWidth < 50) {
            backButtonWidth = 50
            backButtonHeight = backButtonHeight * bRatio
        }
        
        backButton = UIButton(frame: CGRect(x: infoWidth / 50, y: infoHeight / 50, width: backButtonWidth, height: backButtonHeight))
        backButton.backgroundColor = UIColor.red
        backButton.setTitle("Back", for: .normal)
        backButton.addTarget(self, action:#selector(self.backBtn), for: .touchUpInside)
        infoViewT.addSubview(backButton)
        
        var viewButtonWidth = mapWidth / 15
        var viewButtonHeight = mapHeight / 15
        let vRatio = viewButtonWidth / viewButtonHeight
        if (viewButtonWidth < 50) {
            viewButtonWidth = 50
            viewButtonHeight = viewButtonHeight * vRatio
        }
        
        viewButton = UIButton(frame: CGRect(x: mapWidth - (mapWidth * 0.02 + viewButtonWidth), y: mapHeight - (mapHeight / 50 + viewButtonHeight), width: viewButtonWidth, height: viewButtonHeight))
        viewButton.backgroundColor = UIColor.green
        viewButton.setTitle("View", for: .normal)
        viewButton.addTarget(self, action:#selector(self.viewBtn), for: .touchUpInside)
        
        resourceButton = UIButton(frame: CGRect(x: mapWidth - ( mapWidth * 0.02 + viewButtonWidth), y: mapHeight * 0.02, width: viewButtonWidth, height: viewButtonHeight))
        resourceButton.backgroundColor = UIColor.brown
        resourceButton.setTitle("Resources", for: .normal)
        let thing = resourceButton.titleLabel!.font
        print(thing?.familyName)
        resourceButton.titleLabel!.adjustsFontSizeToFitWidth = true
        resourceButton.addTarget(self, action:#selector(self.resourceBtn), for: .touchUpInside)
        
        infoButton1 = UIButton(frame: CGRect(x: mapWidth * 0.02, y: mapHeight - ( mapHeight * 0.02 + viewButtonHeight), width: viewButtonHeight, height: viewButtonHeight))
        let questionMark = UIImage(named: "questionMark")
        infoButton1.setBackgroundImage(questionMark, for: .normal)
        infoButton1.addTarget(self, action:#selector(self.infoBtn1), for: .touchUpInside)
        
        infoButton2 = UIButton(frame: CGRect(x: backButtonWidth + infoWidth * 0.05, y: infoHeight * 0.02, width: backButtonHeight, height: backButtonHeight))
        infoButton2.setBackgroundImage(questionMark, for: .normal)
        infoButton2.addTarget(self, action:#selector(self.infoBtn2), for: .touchUpInside)
        
        let names = UILabel(frame: CGRect(x: viewButtonHeight + mapWidth * 0.03, y: mapView.frame.height * 0.9, width: mapView.frame.width * 0.4, height: mapView.frame.height * 0.1))
        names.text = "By Dr. Joseph M. McManus Jr., DMD, and Christopher Hart"
        names.adjustsFontSizeToFitWidth = true
        
        mapView.addSubview(names)
        
        mapView.addSubview(infoButton1)
        mapView.addSubview(resourceButton)
        infoView.addSubview(infoButton2)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(regionTapped(tapGestureRecognizer:)))
        imgView.isUserInteractionEnabled = true
        imgView.addGestureRecognizer(tapGestureRecognizer)
        
        let widthRate = Double(size.width/1307.98380566802)
        let heightRate = Double(size.height/1024.0)
        
        let regionPoints = getRegionsBezier().map{(name: $0.name, path: $0.path.map{(x: $0.x * widthRate, y: $0.y * heightRate)})}
        
        let regionPopUps = [(src: "mini_longIsland", name: "Long Island", x: 985, y: 837), (src: "mini_newYorkCity", name: "New York City", x: 905, y: 920), (src: "mini_midHudson", name: "Mid Hudson", x: 762, y: 640), (src: "mini_capitalDistrict", name: "Capital District", x: 858, y: 360.52), (src: "mini_mohawkValley", name: "Mohawk Valley", x: 715, y: 208), (src: "mini_northCountry", name: "North Country", x: 804, y: 2), (src: "mini_tugHillSeaway", name: "Tug Hill Seaway", x: 546, y: 2), (src: "mini_centralNewYork", name: "Central New York", x: 496, y: 290.52), (src: "mini_southernTier", name: "Southern Tier", x: 506, y: 511), (src: "mini_fingerLakes", name: "Finger Lakes", x: 282, y: 369), (src: "mini_westernNewYork", name: "Western New York", x: 0, y: 369)]
        
        let bezAndPopUp = Array(zip(regionPoints, regionPopUps))
        let scale = size.width / (img?.size.width)!
        
        regionPaths = bezAndPopUp.map({(value) in
            let path = UIBezierPath()
            path.move(to: CGPoint(x: value.0.path[0].x, y: value.0.path[0].y))
            for i in 1...(value.0.path.count - 1) {
                path.addLine(to: CGPoint(x: value.0.path[i].x, y: value.0.path[i].y))
            }
            
            let img = UIImage(named: value.1.src)
            let imgView = UIImageView(image: img)
            imgView.tag = 1
            
            let regionSize = (width: CGFloat((img?.size.width)! * scale), height: CGFloat((img?.size.height)! * scale))
            imgView.frame = CGRect(x: center.x + CGFloat(value.1.x) * CGFloat(widthRate), y: center.y + CGFloat(value.1.y) * CGFloat(heightRate), width: regionSize.width, height: regionSize.height)
            
            return (imgView: imgView, name: value.1.name, path: path)
        })
        
        let regionImgs = [(src: "longIsland", name: "Long Island", size: (width: CGFloat(901.56), height: CGFloat(454.694589178357))), (src: "newYorkCity", name: "New York City", size: (width: CGFloat(901.56), height: CGFloat(906.801627906977))), (src: "midHudson", name: "Mid Hudson", size: (width: CGFloat(901.56), height: CGFloat(947.671534391534))), (src: "capitalDistrict", name: "Capital District", size: (width: CGFloat(633.53975227085), height: CGFloat(963.84))), (src: "mohawkValley", name: "Mohawk Valley", size: (width: CGFloat(528.206101694915), height: CGFloat(963.84))), (src: "northCountry", name: "North Country", size: (width: CGFloat(546.017733990148), height: CGFloat(963.84))), (src: "tugHillSeaway", name: "Tug Hill Seaway", size: (width: CGFloat(828.855036855037), height: CGFloat(963.84))), (src: "centralNewYork", name: "Central New York", size: (width: CGFloat(901.56), height: CGFloat(963.486958073149))), (src: "southernTier", name: "Southern Tier", size: (width: CGFloat(901.56), height: CGFloat(490.262306238185))), (src: "fingerLakes", name: "Finger Lakes", size: (width: CGFloat(785.05681780709), height: CGFloat(963.84))), (src: "westernNewYork", name: "Western New York", size: (width: CGFloat(901.56), height: CGFloat(835.79270516717)))]
        
        let countyBezier = getCountyBezier()
        //now change the dimensions
        
        
        let countiesInRegionBezier = regionImgs.map{(value: (src: String, name: String, size: (width: CGFloat, height: CGFloat))) -> (src: String, size: (width: CGFloat, height: CGFloat), name: String, counties: [(name: String, path: [(x: Double, y: Double)])]) in
            let bez = countyBezier.filter{$0.region == value.src}
            let bezWithoutRegion = bez.map{(name: $0.name, path: $0.path)}
            let region = (src: value.src, size: (width: value.size.width, height: value.size.height), name: value.name, counties: bezWithoutRegion)
            return region
        }
        
        let data = getData()
        
        regionImgViews = countiesInRegionBezier.map{(value: (src: String, size: (width: CGFloat, height: CGFloat), name: String, counties: [(name: String, path: [(x: Double, y: Double)])])) -> (imgView: UIImageView, name: String, counties: ([(name: String, path: UIBezierPath, data: (countyName: String, specialPopulation: Bool, geographic: Bool, facility: Bool, nativeAmerican: Bool, dentistLicenses: String, numPeople: String, under5YO: String, gte65YO: String, white: String, africanAmerican: String, americanIndian: String, asian: String, hispOrLat: String, veterans: String, foreignBorn: String, gteHS: String, ba: String, disUnder65: String, woInsuranceUnder65: String, medIncome: String, poverty: String))])) in
            
            
            
            
            let img = UIImage(named: value.src)
            let imgView = UIImageView(image: img)
            let AR = (img?.size.width)! / (img?.size.height)!
            var size = (width: CGFloat(0), height: CGFloat(0))
            let width = infoViewM.frame.width
            let height = infoViewM.frame.height
            if (AR > width / height) {
                size = (width: CGFloat(width), height: CGFloat(width / AR))
            } else if (AR < width / height) {
                size = (width: CGFloat(height * AR), height: CGFloat(height))
            } else {
                size = (width: CGFloat(width), height: CGFloat(height))
            }
            let center = (x: (width - size.width) / 2, y: (height - size.height) / 2)
            imgView.frame = CGRect(x: center.x, y: center.y, width: size.width, height: size.height)
            
            let widthRate = Double(size.width / value.size.width)
            let heightRate = Double(size.height / value.size.height)
            
            let countyPaths = value.counties.map{(value: (name: String, path: [(x: Double, y: Double)])) -> (name: String, path: UIBezierPath) in
                let path = UIBezierPath()
                
                path.move(to: CGPoint(x: value.path[0].x * widthRate, y: value.path[0].y * heightRate))
                
                for i in 1...(value.path.count - 1) {
                    path.addLine(to: CGPoint(x: value.path[i].x * widthRate, y: value.path[i].y * heightRate))
                }
                return (name: value.name, path: path)
            }
            
            let counties = countyPaths.map{(value: (name: String, path: UIBezierPath)) -> (name: String, path: UIBezierPath, data: (countyName: String, specialPopulation: Bool, geographic: Bool, facility: Bool, nativeAmerican: Bool, dentistLicenses: String, numPeople: String, under5YO: String, gte65YO: String, white: String, africanAmerican: String, americanIndian: String, asian: String, hispOrLat: String, veterans: String, foreignBorn: String, gteHS: String, ba: String, disUnder65: String, woInsuranceUnder65: String, medIncome: String, poverty: String)) in
                
                let data = data.first(where: {$0.countyName == value.name})
                return (name: value.name, path: value.path, data: data!)
            }
            
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(countyTapped(tapGestureRecognizer:)))
            imgView.isUserInteractionEnabled = true
            imgView.addGestureRecognizer(tapGestureRecognizer)
            
            return (imgView: imgView, name: value.name, counties: counties)

        }
    }
    
    func regionTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        if (regionPaths.count > 0 && !windowOpen) {
            let point = tapGestureRecognizer.location(in: tapGestureRecognizer.view)
            var i = 0
            var flag = false
            while (i < regionPaths.count && !flag) {
                if (regionPaths[i].path.contains(CGPoint(x: point.x, y: point.y))) {
                    flag = true
                } else {
                    i += 1
                }
            }
            if (i < regionPaths.count) {
                let lastImgView = mapView.subviews.filter{ $0.tag == 1}
                if (lastImgView.count > 0) {
                    lastImgView[0].removeFromSuperview()
                }
                regionTitle.removeFromSuperview()
                
                viewClicked = i
                mapView.addSubview(regionPaths[i].imgView)
                
                regionTitle = UILabel(frame: CGRect(x: mapView.frame.width / 50, y: mapView.frame.height / 10, width: mapView.frame.width / 4, height: mapView.frame.height / 5))
                regionTitle.font = regionTitle.font.withSize(mapView.frame.height / 5)
                regionTitle.adjustsFontSizeToFitWidth = true
                regionTitle.text = regionPaths[i].name
                mapView.addSubview(regionTitle)
                mapView.addSubview(viewButton)
            }
        }
    }
    
    func countyTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        if (!windowOpen) {
            let point = tapGestureRecognizer.location(in: tapGestureRecognizer.view)

            let region = regionImgViews[viewClicked!]
            let county = region.counties.first(where: {$0.path.contains(CGPoint(x: point.x, y: point.y))})
            if (county != nil) {
                setToggle(state: false)
                
                currentCountyText = dataText(regionType: "County", data: county!.data)
                currentData.text = currentCountyText
            }
        }
    }
    
    //simply returns a new string of data
    func dataText(regionType: String, data: (countyName: String, specialPopulation: Bool, geographic: Bool, facility: Bool, nativeAmerican: Bool, dentistLicenses: String, numPeople: String, under5YO: String, gte65YO: String, white: String, africanAmerican: String, americanIndian: String, asian: String, hispOrLat: String, veterans: String, foreignBorn: String, gteHS: String, ba: String, disUnder65: String, woInsuranceUnder65: String, medIncome: String, poverty: String)) -> String {
    
        let text = "\n\(data.countyName) \(regionType)\n\n" +
            "Dental Care HPSAs\n\n" +
            (data.specialPopulation ? "☒" : "☐") + "  Special Population" + "\n" +
            (data.geographic ? "☒" : "☐") + "  Geographic" + "\n" +
            (data.facility ? "☒" : "☐") + "  Facility" + "\n" +
            (data.nativeAmerican ? "☒" : "☐") + "  Native American" + "\n\n" +
            "Dental Licenses  \(data.dentistLicenses)\n" +
            "Number of People  \(data.numPeople)\n" +
            "Under 5 years old \(data.under5YO)\n" +
            "Age 65 and older  \(data.gte65YO)\n\n" +
            "Racial Demographics:\n\n" +
            "White  \(data.white)\n" +
            "African American  \(data.africanAmerican)\n" +
            "American Indian  \(data.americanIndian)\n" +
            "Asian  \(data.asian)\n" +
            "Hispanic or Latino  \(data.hispOrLat)\n\n" +
            "Population Characteristics:\n\n" +
            "Veterans  \(data.veterans)\n" +
            "Foreign Born  \(data.foreignBorn)\n\n" +
            "Education:\n\n" +
            "High School Education or Higher  \(data.gteHS)\n" +
            "Bachelors Degree or Higher  \(data.ba)\n\n" +
            "Health:\n\n" +
            "With a disability under age 65  \(data.disUnder65)\n" +
            "Without health insurance under age 65  \(data.woInsuranceUnder65)\n\n" +
            "Income and Poverty:\n\n" +
            "Median Household Income \(data.medIncome)\n" +
            "Persons in Povery \(data.poverty)\n"
        
        return text
    }

    func scrollViewInit(x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat, data: (countyName: String, specialPopulation: Bool, geographic: Bool, facility: Bool, nativeAmerican: Bool, dentistLicenses: String, numPeople: String, under5YO: String, gte65YO: String, white: String, africanAmerican: String, americanIndian: String, asian: String, hispOrLat: String, veterans: String, foreignBorn: String, gteHS: String, ba: String, disUnder65: String, woInsuranceUnder65: String, medIncome: String, poverty: String)) -> UIScrollView {
        
        let scrollView = UIScrollView(frame: CGRect(x: x, y: y, width: width, height: height))
        scrollView.backgroundColor = UIColor.white
        
        let text = dataText(regionType: "State", data: data)
        
        let sizingLabel = UILabel(frame: CGRect(x:0,y:0,width:0,height:0))
        sizingLabel.text = text
        sizingLabel.numberOfLines = 0;
        let height = sizingLabel.intrinsicContentSize.height
        
        scrollView.contentSize = CGSize(width:0, height: height)
        scrollView.layer.borderWidth = 2
        scrollView.layer.borderColor = UIColor.black.cgColor
        
        return scrollView
    }

    
    func backBtn() {
        if (!windowOpen) {
            toggle.removeFromSuperview()
            regionTitleI.removeFromSuperview()
            scrollView.removeFromSuperview()
            regionImgViews[viewClicked!].imgView.removeFromSuperview()
            infoView.removeFromSuperview()
            self.view.addSubview(mapView)
        }
    }
    
    func viewBtn() {
        if (!windowOpen) {
            scrollView = scrollViewInit(x: infoViewT.frame.width * 0.03, y: infoViewT.frame.height * 0.4, width: infoViewT.frame.width * 0.94, height: infoViewT.frame.height * 0.6 - infoViewT.frame.width * 0.03, data: getData()[2])
            currentData = UILabel(frame: CGRect(x: scrollView.frame.width * 0.03, y: 0, width: scrollView.frame.width * 0.94, height: scrollView.contentSize.height))
            
            currentData.numberOfLines = 0
            currentData.adjustsFontSizeToFitWidth = true
            
            nyText = dataText(regionType: "State", data: (countyName: "New York", specialPopulation: true, geographic: true, facility: true, nativeAmerican: true, dentistLicenses: "15077", numPeople: "19,745,289", under5YO: "5.9%", gte65YO: "15.4%", white: "69.9%", africanAmerican: "17.7%%", americanIndian: "1%", asian: "8.9%", hispOrLat: "19%", veterans: "828,586", foreignBorn: "22.5%", gteHS: "85.6%", ba: "34.2%", disUnder65: "7.4%", woInsuranceUnder65: "8.1%", medIncome: "$59,269", poverty: "15.4%"))
            currentData.text = nyText
            currentCountyText = ""
            
            regionTitleI = UILabel(frame: CGRect(x: infoViewT.frame.width * 0.03, y: infoViewT.frame.height * 0.1, width: infoViewT.frame.width * 0.94, height: infoViewT.frame.height * 0.2))
            regionTitleI.font = regionTitleI.font.withSize(infoViewT.frame.height * 0.2)
            regionTitleI.adjustsFontSizeToFitWidth = true
            regionTitleI.text = regionImgViews[viewClicked!].name
            
            toggle = UIButton(frame: CGRect(x: infoViewT.frame.width * 0.03, y: infoViewT.frame.height * 0.3, width: infoViewT.frame.width * 0.94, height: infoViewT.frame.height * 0.1))
            toggle.backgroundColor = UIColor.white
            toggle.setTitle("Show County Data", for: .normal)
            toggle.setTitleColor(UIColor.black, for: .normal)
            toggle.addTarget(self, action:#selector(self.toggleBtn), for: .touchUpInside)
            
            mapView.removeFromSuperview()
            self.view.addSubview(infoView)
            scrollView.addSubview(currentData)
            infoViewT.addSubview(regionTitleI)
            infoViewT.addSubview(toggle)
            infoViewT.addSubview(scrollView)
            infoViewM.addSubview(regionImgViews[viewClicked!].imgView)
        }
    }
    
    func toggleBtn() {
        if (!windowOpen) {
            if (toggleState) {
                toggleState = false
                toggle.setTitle("Show County Data", for: .normal)
                currentData.text = nyText
            } else {
                toggleState = true
                toggle.setTitle("Show State Data", for: .normal)
                currentData.text = currentCountyText
            }
        }
    }
    
    func setToggle(state: Bool) {
        if (!windowOpen) {
            if (state) {
                toggleState = false
                toggle.setTitle("Show County Data", for: .normal)
            } else {
                toggleState = true
                toggle.setTitle("Show State Data", for: .normal)
            }
        }
    }
    
    func resourceBtn() {
        if (!windowOpen) {
            windowOpen = true
            let resourceView = UIView(frame: CGRect(x: mapView.frame.width/2, y: 0, width: mapView.frame.width/2, height: mapView.frame.height))
            resourceView.backgroundColor = UIColor.white
            resourceView.layer.borderWidth = 3
            resourceView.layer.borderColor = UIColor.black.cgColor
            
            let button = getCloseBtn(x: resourceView.frame.width * 0.93, y: resourceView.frame.height * 0.02, width: resourceView.frame.width * 0.05, height: resourceView.frame.width * 0.05)
            let label = getReferenceLabel(x: resourceView.frame.width * 0.01, y: 0, width: resourceView.frame.width * 0.98, height: resourceView.frame.height)
            resourceView.addSubview(label)
            resourceView.addSubview(button)
            mapView.addSubview(resourceView)
        }
    }
    
    func infoBtn1() {
        if (!windowOpen) {
            windowOpen = true
            let resourceView = UIView(frame: CGRect(x: mapView.frame.width/2, y: 0, width: mapView.frame.width/2, height: mapView.frame.height))
            resourceView.backgroundColor = UIColor.white
            resourceView.layer.borderWidth = 3
            resourceView.layer.borderColor = UIColor.black.cgColor
            
            let button = getCloseBtn(x: resourceView.frame.width * 0.93, y: resourceView.frame.height * 0.02, width: resourceView.frame.width * 0.05, height: resourceView.frame.width * 0.05)
            let label = getInfoLabel(x: resourceView.frame.width * 0.01, y: 0, width: resourceView.frame.width * 0.98, height: resourceView.frame.height)
            resourceView.addSubview(label)
            resourceView.addSubview(button)
            mapView.addSubview(resourceView)

        }
    }
    
    func infoBtn2() {
        if (!windowOpen) {
            windowOpen = true
            let resourceView = UIView(frame: CGRect(x: mapView.frame.width/2, y: 0, width: mapView.frame.width/2, height: mapView.frame.height))
            resourceView.backgroundColor = UIColor.white
            resourceView.layer.borderWidth = 3
            resourceView.layer.borderColor = UIColor.black.cgColor
            
            let button = getCloseBtn(x: resourceView.frame.width * 0.93, y: resourceView.frame.height * 0.02, width: resourceView.frame.width * 0.05, height: resourceView.frame.width * 0.05)
            let label = getInfoLabel(x: resourceView.frame.width * 0.01, y: 0, width: resourceView.frame.width * 0.98, height: resourceView.frame.height)
            resourceView.addSubview(label)
            resourceView.addSubview(button)
            infoView.addSubview(resourceView)

        }
    }
    
    func getReferenceLabel(x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat) -> UILabel {
        let label = UILabel(frame: CGRect(x: x, y: y, width: width, height: height))
        label.text = "Sources\n\n" +
            
                    "Health Shortage Areas\n" +
                    "Data and resources from the U.S. Department of Health and Human Services\n" +
                    "Data and resources from the New York State Department of Health\n\n" +
                    
                    "Dentist Licensure Statistics\n" +
                    "Data from the New York Department of Education, Office of the Professions\n\n" +
                    
                    "Demographics\n" +
                    "Data from the United States Census Bureau, Population Estimates Program\n"
        label.numberOfLines = 0
        label.adjustsFontSizeToFitWidth = true
        return label
    }
    
    func getInfoLabel(x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat) -> UILabel {
        let label = UILabel(frame: CGRect(x: x, y: y, width: width, height: height))
        label.text = "Explanations/Clarifications\n\n" +
            
                    "(1) Health Professional Shortage Areas (HPSAs) are designations that indicate health care provider and service shortages in: Primary care, Dental health, or Mental Health. These shortages may be geographic, population, or facility based. The Human Resources and Service Administration works with state partners to determine the shortage designation status, and provides federal resources from there.\n\n" +
            
                    "(1b) Dental Health HPSA scoring is calculated between a score of 0-26. 10 points are allotted to the population-to-provider ration, 10 points is allotted to percent of population below 100% federal poverty level, 1 point is allotted Water fluoridation status, 5 points are allotted to nearest source of care. The status allows the area to qualify for the National Health Service Corps Scholarship. This scholarship pays tuition, fees, other educational costs, and provides a living stipend in return for a commitment to work at least 2 years at this qualifying site.\n\n" +
                    
                    "(2) Geographic-based: A shortage of providers for the entire population within a defined geographic area.\n\n" +
            
                    "(3) Population-based: A shortage of providers for a specific population group within a defined geographic area.\n\n" +
                    
                    "(4) Facility-based: Medical facilities serving a population or geographic area designated as a HPSA with a shortage of health providers.\n\n" +
                    
                    "(5) Racial demographics:\n" +
                    "White, African American, Asian: Includes persons reporting only one race\n" +
                    "Hispanics: May be of any race, so also included in applicable race categories\n"
        label.numberOfLines = 0
        label.adjustsFontSizeToFitWidth = true
        return label
    }
    
    func closeBtn(button: UIButton) {
        button.superview?.removeFromSuperview()
        windowOpen = false
    }
    
    func getCloseBtn(x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat) -> UIButton {
        let button = UIButton(frame: CGRect(x: x, y: y, width: width, height: height))
        let img = UIImage(named: "closeButton")
        button.setBackgroundImage(img, for: .normal)
        button.addTarget(self, action:#selector(self.closeBtn(button:)), for: .touchUpInside)
        return button
    }
    
    
    
    func getRegionsBezier() -> [(name: String, path: [(x: Double, y: Double)])] {
        let longIsland = [(x: 990.991902834008, y: 950.5), (x: 998.491902834008, y: 935.5), (x: 1052.49190283401, y: 915.0), (x: 1087.99190283401, y: 913.5), (x: 1181.99190283401, y: 907.0), (x: 1288.49190283401, y: 832.5), (x: 1296.99190283401, y: 846.5), (x: 1260.99190283401, y: 865.5), (x: 1262.49190283401, y: 881.0), (x: 1078.49190283401, y: 994.0), (x: 1020.49190283401, y: 1002.0), (x: 989.991902834008, y: 1001.0), (x: 997.991902834008, y: 970.0)]
        let newYorkCity = [(x: 991.991902834008, y: 996.5), (x: 1002.49190283401, y: 966.5), (x: 987.491902834008, y: 949.0), (x: 987.491902834008, y: 934.5), (x: 964.491902834008, y: 924.5), (x: 939.491902834008, y: 980.0), (x: 914.491902834008, y: 983.5), (x: 907.491902834008, y: 1020.5), (x: 944.991902834008, y: 999.5), (x: 961.991902834008, y: 1012.5), (x: 990.991902834008, y: 1001.0)]
        let midHudson = [(x: 1036.99190283401, y: 670.0), (x: 1027.49190283401, y: 840.0), (x: 1040.99190283401, y: 857.5), (x: 1000.49190283401, y: 885.5), (x: 1012.49190283401, y: 909.5), (x: 990.491902834008, y: 931.5), (x: 964.991902834008, y: 925.0), (x: 966.491902834008, y: 906.5), (x: 832.491902834008, y: 827.0), (x: 783.991902834008, y: 795.0), (x: 759.991902834008, y: 720.5), (x: 875.991902834008, y: 645.0), (x: 899.991902834008, y: 653.5), (x: 939.991902834008, y: 659.5), (x: 948.491902834008, y: 644.0), (x: 965.491902834008, y: 651.5), (x: 965.491902834008, y: 662.0), (x: 1002.49190283401, y: 682.0), (x: 1026.99190283401, y: 683.5)]
        let capitalDistrict = [(x: 1014.49190283401, y: 468.0), (x: 1070.49190283401, y: 469.5), (x: 1075.99190283401, y: 512.0), (x: 1029.99190283401, y: 681.5), (x: 1029.99190283401, y: 685.5), (x: 964.491902834008, y: 662.5), (x: 964.491902834008, y: 652.0), (x: 947.991902834008, y: 642.5), (x: 940.991902834008, y: 660.0), (x: 900.491902834008, y: 654.5), (x: 863.991902834008, y: 637.0), (x: 887.991902834008, y: 600.0), (x: 905.491902834008, y: 601.5), (x: 908.491902834008, y: 589.5), (x: 916.991902834008, y: 566.0), (x: 912.991902834008, y: 557.0), (x: 923.491902834008, y: 524.0), (x: 905.491902834008, y: 518.0), (x: 909.991902834008, y: 504.5), (x: 937.491902834008, y: 480.5), (x: 935.991902834008, y: 466.0), (x: 926.491902834008, y: 374.5), (x: 970.991902834008, y: 368.5), (x: 986.991902834008, y: 401.5), (x: 1016.49190283401, y: 387.0), (x: 1023.49190283401, y: 439.5), (x: 1013.99190283401, y: 465.0)]
        let mohawkValley = [(x: 812.991902834008, y: 220.0), (x: 824.991902834008, y: 349.5), (x: 809.991902834008, y: 377.0), (x: 862.991902834008, y: 402.0), (x: 929.491902834008, y: 400.5), (x: 937.991902834008, y: 477.5), (x: 903.991902834008, y: 509.5), (x: 923.991902834008, y: 522.5), (x: 910.491902834008, y: 592.0), (x: 880.991902834008, y: 602.5), (x: 835.491902834008, y: 566.5), (x: 723.491902834008, y: 609.5), (x: 748.491902834008, y: 486.5), (x: 751.491902834008, y: 443.5), (x: 775.991902834008, y: 403.0), (x: 760.491902834008, y: 391.5), (x: 773.991902834008, y: 381.0), (x: 759.991902834008, y: 212.0), (x: 779.491902834008, y: 220.5)]
        let northCountry = [(x: 1071.49190283401, y: 470.0), (x: 1012.49190283401, y: 467.5), (x: 1017.99190283401, y: 389.0), (x: 985.991902834008, y: 403.0), (x: 968.991902834008, y: 367.0), (x: 924.991902834008, y: 376.0), (x: 924.991902834008, y: 399.5), (x: 868.491902834008, y: 405.0), (x: 811.991902834008, y: 379.0), (x: 828.491902834008, y: 347.5), (x: 813.991902834008, y: 218.5), (x: 863.991902834008, y: 211.0), (x: 846.991902834008, y: 23.0), (x: 832.991902834008, y: 0.0), (x: 1060.99190283401, y: 0.0), (x: 1062.49190283401, y: 25.5), (x: 1061.49190283401, y: 48.5), (x: 1058.99190283401, y: 102.5), (x: 1070.99190283401, y: 172.0), (x: 1050.49190283401, y: 222.5), (x: 1056.99190283401, y: 281.5), (x: 1052.99190283401, y: 316.5), (x: 1074.99190283401, y: 326.0)]
        let tugHillSeaway = [(x: 860.491902834008, y: 209.0), (x: 777.991902834008, y: 218.5), (x: 757.491902834008, y: 207.0), (x: 765.991902834008, y: 316.0), (x: 696.991902834008, y: 359.5), (x: 666.991902834008, y: 344.0), (x: 659.991902834008, y: 301.5), (x: 590.491902834008, y: 305.0), (x: 574.491902834008, y: 268.5), (x: 547.991902834008, y: 256.5), (x: 571.991902834008, y: 187.0), (x: 646.991902834008, y: 141.5), (x: 818.491902834008, y: 0), (x: 845.991902834008, y: 22.5)]
        let centralNewYork = [(x: 771.491902834008, y: 324.0), (x: 777.991902834008, y: 378.5), (x: 761.991902834008, y: 390.5), (x: 772.491902834008, y: 404.5), (x: 748.491902834008, y: 443.0), (x: 751.491902834008, y: 482.5), (x: 738.491902834008, y: 513.0), (x: 643.491902834008, y: 520.0), (x: 643.491902834008, y: 586.0), (x: 582.991902834008, y: 584.5), (x: 578.991902834008, y: 542.0), (x: 514.991902834008, y: 541.5), (x: 500.491902834008, y: 508.0), (x: 504.991902834008, y: 379.5), (x: 521.491902834008, y: 366.5), (x: 558.991902834008, y: 336.0), (x: 582.991902834008, y: 335.5), (x: 589.491902834008, y: 306.5), (x: 658.491902834008, y: 301.5), (x: 666.991902834008, y: 350.0), (x: 698.991902834008, y: 361.0)]
        let southernTier = [(x: 724.491902834008, y: 678.5), (x: 762.991902834008, y: 713.0), (x: 871.991902834008, y: 646.0), (x: 863.991902834008, y: 633.5), (x: 879.991902834008, y: 602.0), (x: 834.991902834008, y: 566.0), (x: 723.491902834008, y: 611.0), (x: 737.991902834008, y: 519.5), (x: 644.991902834008, y: 521.0), (x: 644.991902834008, y: 589.5), (x: 581.491902834008, y: 588.5), (x: 576.491902834008, y: 542.0), (x: 516.491902834008, y: 540.5), (x: 527.491902834008, y: 558.5), (x: 511.991902834008, y: 562.0), (x: 511.991902834008, y: 612.5), (x: 533.991902834008, y: 619.5), (x: 532.491902834008, y: 681.0)]
        let fingerLakes = [(x: 532.491902834008, y: 677.5), (x: 532.991902834008, y: 618.5), (x: 509.491902834008, y: 613.5), (x: 511.491902834008, y: 558.5), (x: 521.991902834008, y: 558.5), (x: 500.991902834008, y: 519.5), (x: 507.491902834008, y: 380.5), (x: 395.491902834008, y: 392.5), (x: 366.491902834008, y: 403.0), (x: 336.991902834008, y: 378.0), (x: 296.491902834008, y: 368.5), (x: 296.491902834008, y: 422.5), (x: 311.991902834008, y: 424.0), (x: 302.991902834008, y: 481.0), (x: 303.491902834008, y: 526.5), (x: 286.991902834008, y: 560.5), (x: 338.991902834008, y: 572.5), (x: 334.991902834008, y: 678.5)]
        let WesternNewYork = [(x: 337.491902834008, y: 679.5), (x: 337.491902834008, y: 574.0), (x: 289.991902834008, y: 561.5), (x: 302.491902834008, y: 528.0), (x: 300.491902834008, y: 482.0), (x: 311.491902834008, y: 457.0), (x: 311.491902834008, y: 428.0), (x: 295.991902834008, y: 424.0), (x: 295.991902834008, y: 372.0), (x: 218.491902834008, y: 370.5), (x: 119.991902834008, y: 394.5), (x: 118.491902834008, y: 435.0), (x: 128.991902834008, y: 441.0), (x: 127.491902834008, y: 455.5), (x: 144.991902834008, y: 465.5), (x: 143.991902834008, y: 480.0), (x: 154.491902834008, y: 505.0), (x: 121.991902834008, y: 521.5), (x: 109.991902834008, y: 552.5), (x: 5.4919028340081, y: 618.5), (x: 3.9919028340081, y: 679.0)]

        let regions =  [(name: "longIsland", path: longIsland), (name: "newYorkCity", path: newYorkCity), (name: "midHudson", path: midHudson), (name: "capitalDistrict", path: capitalDistrict), (name: "mohawkValley", path: mohawkValley), (name: "northCountry", path: northCountry), (name: "tugHillSeaway", path: tugHillSeaway), (name: "centralNewYork", path: centralNewYork), (name: "southernTier", path: southernTier), (name: "fingerLakes", path: fingerLakes), (name: "westernNewYork", path: WesternNewYork)]
        return regions
    }
    
    func getCountyBezier() -> [(name: String, region: String, path: [(x: Double, y: Double)])] {
        //columbia
        let manhattan = [(x: 382.88, y: 519.4), (x: 414.88, y: 494.9), (x: 428.38, y: 463.4), (x: 450.38, y: 460.4), (x: 461.88, y: 454.9), (x: 468.38, y: 457.9), (x: 471.88, y: 438.9), (x: 480.88, y: 422.9), (x: 480.88, y: 394.4), (x: 522.38, y: 319.4), (x: 518.38, y: 313.4), (x: 522.38, y: 306.9), (x: 532.38, y: 309.4), (x: 564.38, y: 273.9), (x: 561.38, y: 267.9), (x: 541.38, y: 250.9), (x: 535.38, y: 250.9), (x: 528.38, y: 239.4), (x: 526.88, y: 180.9), (x: 536.38, y: 152.4), (x: 561.38, y: 117.4), (x: 568.88, y: 98.4), (x: 562.88, y: 87.4), (x: 552.38, y: 91.9), (x: 521.88, y: 79.9), (x: 473.88, y: 200.9), (x: 392.88, y: 350.9), (x: 373.88, y: 448.9), (x: 384.88, y: 465.9), (x: 375.38, y: 497.4), (x: 380.88, y: 514.9)]
        let bronx = [(x: 523.38, y: 80.9008139534885), (x: 546.88, y: 5.40081395348847), (x: 637.88, y: 38.4008139534885), (x: 655.88, y: 19.4008139534885), (x: 674.88, y: 28.9008139534885), (x: 681.88, y: 53.9008139534885), (x: 769.88, y: 83.4008139534885), (x: 800.88, y: 144.400813953488), (x: 798.38, y: 168.900813953488), (x: 761.88, y: 182.900813953488), (x: 739.88, y: 161.900813953488), (x: 719.88, y: 170.400813953488), (x: 729.38, y: 207.400813953488), (x: 746.88, y: 221.900813953488), (x: 765.88, y: 254.900813953488), (x: 752.88, y: 260.900813953488), (x: 716.88, y: 248.400813953488), (x: 640.88, y: 265.400813953488), (x: 629.38, y: 276.400813953488), (x: 625.88, y: 286.900813953488), (x: 593.88, y: 286.900813953488), (x: 590.88, y: 282.400813953488), (x: 559.88, y: 269.900813953488), (x: 541.88, y: 255.400813953488), (x: 534.88, y: 255.400813953488), (x: 527.38, y: 239.400813953488), (x: 523.88, y: 182.400813953488), (x: 532.38, y: 155.900813953488), (x: 558.88, y: 115.900813953488), (x: 564.88, y: 100.400813953488), (x: 561.38, y: 93.9008139534885), (x: 552.88, y: 97.9008139534885), (x: 519.88, y: 83.4008139534885)]
        let kings = [(x: 381.38, y: 517.400813953489), (x: 410.38, y: 493.400813953488), (x: 424.88, y: 458.900813953488), (x: 447.38, y: 459.900813953488), (x: 464.38, y: 451.400813953488), (x: 478.38, y: 421.900813953488), (x: 476.88, y: 390.900813953488), (x: 491.38, y: 383.900813953488), (x: 513.38, y: 392.400813953488), (x: 519.88, y: 402.400813953488), (x: 534.88, y: 407.900813953488), (x: 543.88, y: 433.400813953488), (x: 546.38, y: 448.900813953488), (x: 571.88, y: 477.900813953488), (x: 582.38, y: 504.400813953488), (x: 618.38, y: 480.400813953488), (x: 630.38, y: 479.400813953488), (x: 647.88, y: 530.400813953489), (x: 648.88, y: 554.400813953489), (x: 642.38, y: 562.900813953489), (x: 652.88, y: 588.900813953489), (x: 662.88, y: 588.900813953489), (x: 686.38, y: 618.400813953489), (x: 686.38, y: 667.900813953489), (x: 660.88, y: 705.400813953489), (x: 609.88, y: 739.900813953489), (x: 511.38, y: 757.900813953489), (x: 494.88, y: 746.900813953489), (x: 421.88, y: 752.900813953489), (x: 391.88, y: 742.400813953489), (x: 388.88, y: 727.400813953489), (x: 411.38, y: 703.900813953489), (x: 400.88, y: 689.400813953489), (x: 363.88, y: 680.400813953489), (x: 341.38, y: 631.400813953489), (x: 360.88, y: 578.900813953489), (x: 381.38, y: 552.900813953489)]
        let richmond = [(x: 336.88, y: 673.900813953489), (x: 314.88, y: 626.900813953489), (x: 311.38, y: 594.900813953489), (x: 300.88, y: 574.900813953489), (x: 281.88, y: 572.400813953489), (x: 177.88, y: 596.400813953489), (x: 145.88, y: 587.900813953489), (x: 130.38, y: 579.900813953489), (x: 109.38, y: 590.400813953489), (x: 93.3799999999999, y: 611.400813953489), (x: 87.3799999999999, y: 641.900813953489), (x: 96.3799999999999, y: 653.400813953489), (x: 101.38, y: 687.400813953489), (x: 88.3799999999999, y: 702.900813953489), (x: 78.3799999999999, y: 763.900813953489), (x: 64.8799999999999, y: 774.900813953489), (x: 51.8799999999999, y: 771.400813953489), (x: 18.3799999999999, y: 801.400813953489), (x: 26.8799999999999, y: 826.400813953489), (x: 26.8799999999999, y: 849.400813953489), (x: 2.87999999999994, y: 875.900813953489), (x: 48.3799999999999, y: 896.900813953489), (x: 61.8799999999999, y: 896.900813953489), (x: 81.8799999999999, y: 876.900813953489), (x: 101.38, y: 874.900813953489), (x: 121.38, y: 857.900813953489), (x: 141.88, y: 849.400813953489), (x: 184.38, y: 824.900813953489), (x: 199.88, y: 837.900813953489), (x: 244.38, y: 799.400813953489)]
        let dutchess : [(x: Double, y: Double)] = [(x: 876.88, y: 477.335767195767), (x: 846.38, y: 476.835767195767), (x: 656.88, y: 507.335767195767), (x: 629.38, y: 543.335767195767), (x: 615.88, y: 529.835767195767), (x: 616.88, y: 482.835767195767), (x: 627.38, y: 453.835767195767), (x: 641.38, y: 440.335767195767), (x: 649.38, y: 313.335767195767), (x: 640.38, y: 300.335767195767), (x: 644.88, y: 241.335767195767), (x: 647.88, y: 231.835767195767), (x: 633.38, y: 199.835767195767), (x: 650.88, y: 113.335767195767), (x: 652.38, y: 87.3357671957673), (x: 670.88, y: 75.8357671957673), (x: 766.38, y: 123.335767195767), (x: 867.88, y: 146.335767195767), (x: 871.88, y: 96.8357671957673), (x: 899.38, y: 96.8357671957673)]
        let schenectady = [(x: 362.869876135425, y: 430.42), (x: 189.369876135425, y: 458.92), (x: 183.369876135425, y: 471.92), (x: 129.369876135425, y: 474.92), (x: 108.869876135425, y: 439.92), (x: 145.869876135425, y: 429.92), (x: 136.869876135425, y: 412.92), (x: 136.869876135425, y: 397.92), (x: 222.369876135425, y: 340.92), (x: 219.369876135425, y: 308.42), (x: 246.869876135425, y: 302.42), (x: 290.369876135425, y: 338.42), (x: 316.369876135425, y: 330.92), (x: 325.369876135425, y: 367.92), (x: 364.369876135425, y: 427.42)]
        let greene = [(x: 378.869876135425, y: 632.42), (x: 136.369876135425, y: 672.92), (x: 139.369876135425, y: 682.92), (x: 120.869876135425, y: 693.92), (x: 87.8698761354251, y: 688.92), (x: 44.3698761354251, y: 705.42), (x: 0.369876135425102, y: 815.92), (x: 120.369876135425, y: 878.42), (x: 237.369876135425, y: 889.92), (x: 252.369876135425, y: 842.92), (x: 270.369876135425, y: 836.92), (x: 312.369876135425, y: 866.92), (x: 323.369876135425, y: 833.92), (x: 332.369876135425, y: 829.42), (x: 344.369876135425, y: 813.92), (x: 345.869876135425, y: 788.42), (x: 368.869876135425, y: 779.92), (x: 376.869876135425, y: 765.42), (x: 379.369876135425, y: 741.42), (x: 377.869876135425, y: 716.42), (x: 373.369876135425, y: 692.42), (x: 384.369876135425, y: 651.42)]
        let columbia = [(x: 375.869876135425, y: 631.92), (x: 589.369876135425, y: 603.42), (x: 514.869876135425, y: 888.92), (x: 520.369876135425, y: 914.42), (x: 507.369876135425, y: 915.92), (x: 504.369876135425, y: 961.92), (x: 411.869876135425, y: 945.42), (x: 315.869876135425, y: 895.42), (x: 304.869876135425, y: 893.92), (x: 313.369876135425, y: 857.42), (x: 320.869876135425, y: 830.42), (x: 327.869876135425, y: 828.92), (x: 339.369876135425, y: 811.42), (x: 339.369876135425, y: 789.92), (x: 349.869876135425, y: 778.92), (x: 367.369876135425, y: 774.92), (x: 374.869876135425, y: 745.92), (x: 371.869876135425, y: 719.42), (x: 367.869876135425, y: 691.92), (x: 378.369876135425, y: 652.92)]
        let otsego = [(x: 305.203050847457, y: 682.92), (x: 211.203050847457, y: 642.42), (x: 202.203050847457, y: 681.92), (x: 125.703050847457, y: 637.92), (x: 112.703050847457, y: 666.92), (x: 88.2030508474575, y: 666.92), (x: 87.2030508474575, y: 648.92), (x: 65.7030508474575, y: 654.92), (x: 65.7030508474575, y: 702.42), (x: 38.2030508474575, y: 769.42), (x: 35.2030508474575, y: 805.92), (x: 21.7030508474575, y: 837.92), (x: 6.20305084745746, y: 867.92), (x: 16.7030508474575, y: 912.42), (x: 72.7030508474575, y: 941.42), (x: 93.7030508474575, y: 942.92), (x: 123.203050847457, y: 927.92), (x: 229.203050847457, y: 860.92), (x: 272.703050847457, y: 860.92), (x: 315.203050847457, y: 799.42), (x: 301.703050847457, y: 719.42)]
        let franklin = [(x: 264.608866995074, y: 410.42), (x: 250.108866995074, y: 289.42), (x: 323.108866995074, y: 277.42), (x: 282.608866995074, y: 10.42), (x: 48.1088669950738, y: 6.92000000000002), (x: 49.6088669950738, y: 46.42), (x: 76.6088669950738, y: 41.42), (x: 114.608866995074, y: 386.92), (x: 105.608866995074, y: 391.92), (x: 113.108866995074, y: 434.92)]
        let essex = [(x: 258.108866995074, y: 409.42), (x: 245.608866995074, y: 284.42), (x: 380.108866995074, y: 265.92), (x: 431.108866995074, y: 247.92), (x: 466.108866995074, y: 221.92), (x: 512.108866995074, y: 220.42), (x: 532.608866995074, y: 272.42), (x: 516.608866995074, y: 308.42), (x: 525.108866995074, y: 345.42), (x: 505.608866995074, y: 383.92), (x: 484.108866995074, y: 449.42), (x: 496.608866995074, y: 519.92), (x: 499.108866995074, y: 557.42), (x: 273.608866995074, y: 593.92), (x: 269.608866995074, y: 572.92), (x: 238.108866995074, y: 560.42), (x: 220.108866995074, y: 563.42), (x: 175.608866995074, y: 508.92), (x: 202.108866995074, y: 488.42), (x: 196.108866995074, y: 420.42)]
        let stLawrence = [(x: 594.527518427518, y: 587.42), (x: 819.527518427518, y: 557.92), (x: 818.027518427518, y: 518.42), (x: 827.527518427518, y: 513.92), (x: 776.027518427518, y: 43.92), (x: 742.527518427518, y: 17.92), (x: 695.027518427518, y: 4.92000000000002), (x: 631.527518427518, y: 26.42), (x: 495.027518427518, y: 108.92), (x: 285.027518427518, y: 315.42), (x: 254.027518427518, y: 370.42)]
        let jefferson = [(x: 254.527518427518, y: 367.42), (x: 434.527518427518, y: 484.92), (x: 393.027518427518, y: 553.42), (x: 417.027518427518, y: 567.92), (x: 408.527518427518, y: 610.92), (x: 390.027518427518, y: 610.92), (x: 394.527518427518, y: 634.92), (x: 365.027518427518, y: 634.92), (x: 302.027518427518, y: 688.92), (x: 266.027518427518, y: 688.42), (x: 266.027518427518, y: 734.42), (x: 289.527518427518, y: 740.42), (x: 295.027518427518, y: 806.42), (x: 190.527518427518, y: 795.92), (x: 190.527518427518, y: 819.92), (x: 103.527518427518, y: 811.92), (x: 92.0275184275183, y: 736.42), (x: 66.0275184275183, y: 713.92), (x: 18.0275184275183, y: 657.42), (x: 69.0275184275183, y: 661.92), (x: 121.527518427518, y: 673.92), (x: 129.027518427518, y: 646.42), (x: 102.527518427518, y: 632.92), (x: 71.5275184275183, y: 643.42), (x: 57.0275184275183, y: 600.92), (x: 29.5275184275183, y: 597.92), (x: 60.0275184275183, y: 490.92), (x: 96.5275184275183, y: 489.42), (x: 118.527518427518, y: 463.92), (x: 126.027518427518, y: 434.92), (x: 248.527518427518, y: 369.42)]
        let lewis = [(x: 431.527518427518, y: 482.42), (x: 387.527518427518, y: 554.92), (x: 411.527518427518, y: 571.42), (x: 403.527518427518, y: 606.42), (x: 387.027518427518, y: 606.42), (x: 387.027518427518, y: 631.42), (x: 363.027518427518, y: 629.92), (x: 295.027518427518, y: 684.42), (x: 262.027518427518, y: 681.42), (x: 257.527518427518, y: 741.42), (x: 286.527518427518, y: 744.92), (x: 287.027518427518, y: 797.42), (x: 291.527518427518, y: 933.42), (x: 580.027518427518, y: 847.42), (x: 556.527518427518, y: 562.42)]
        let oswego = [(x: 146.38, y: 363.743479036575), (x: 143.88, y: 342.743479036575), (x: 76.3799999999999, y: 342.743479036575), (x: 68.8799999999999, y: 216.743479036575), (x: 176.38, y: 140.243479036575), (x: 210.38, y: 134.743479036575), (x: 225.38, y: 147.243479036575), (x: 272.38, y: 134.243479036575), (x: 286.88, y: 25.2434790365746), (x: 382.88, y: 33.7434790365746), (x: 382.38, y: 4.24347903657457), (x: 527.88, y: 14.2434790365746), (x: 539.38, y: 177.743479036575), (x: 537.38, y: 188.743479036575), (x: 504.38, y: 176.243479036575), (x: 468.88, y: 284.743479036575), (x: 477.38, y: 290.243479036575), (x: 464.38, y: 414.243479036575), (x: 414.88, y: 396.243479036575), (x: 398.38, y: 397.243479036575), (x: 381.88, y: 385.743479036575), (x: 377.38, y: 381.243479036575), (x: 359.38, y: 382.743479036575), (x: 348.38, y: 366.243479036575), (x: 293.88, y: 328.743479036575), (x: 299.38, y: 363.743479036575), (x: 299.38, y: 373.743479036575), (x: 285.88, y: 380.243479036575), (x: 261.38, y: 355.243479036575), (x: 265.38, y: 366.743479036575), (x: 254.38, y: 380.743479036575), (x: 238.38, y: 359.743479036575)]
        let onondaga = [(x: 415.88, y: 395.743479036575), (x: 430.38, y: 425.243479036575), (x: 428.88, y: 441.243479036575), (x: 418.88, y: 454.743479036575), (x: 449.38, y: 454.743479036575), (x: 461.38, y: 681.243479036575), (x: 258.38, y: 697.243479036575), (x: 209.88, y: 641.243479036575), (x: 157.38, y: 641.243479036575), (x: 152.88, y: 525.243479036575), (x: 136.38, y: 522.743479036575), (x: 135.38, y: 447.743479036575), (x: 145.88, y: 358.243479036575), (x: 240.88, y: 355.243479036575), (x: 257.38, y: 373.243479036575), (x: 257.38, y: 350.243479036575), (x: 285.88, y: 372.743479036575), (x: 290.88, y: 365.243479036575), (x: 289.88, y: 326.743479036575), (x: 296.38, y: 324.243479036575), (x: 368.38, y: 368.243479036575), (x: 362.38, y: 375.243479036575)]
        let tompkins = [(x: 92.3799999999999, y: 258.631153119093), (x: 92.3799999999999, y: 269.131153119093), (x: 117.38, y: 265.631153119093), (x: 117.38, y: 236.131153119093), (x: 139.88, y: 236.131153119093), (x: 139.88, y: 242.631153119093), (x: 165.88, y: 244.131153119093), (x: 165.88, y: 247.131153119093), (x: 182.38, y: 247.131153119093), (x: 186.88, y: 212.631153119093), (x: 163.38, y: 200.631153119093), (x: 163.38, y: 189.631153119093), (x: 182.38, y: 186.631153119093), (x: 176.88, y: 68.6311531190927), (x: 11.3799999999999, y: 71.1311531190927), (x: 35.3799999999999, y: 107.631153119093), (x: 2.37999999999994, y: 109.131153119093), (x: 5.37999999999994, y: 257.131153119093)]
        let tioga = [(x: 94.8799999999999, y: 256.631153119093), (x: 94.8799999999999, y: 263.131153119093), (x: 113.38, y: 263.131153119093), (x: 114.88, y: 234.131153119093), (x: 141.38, y: 234.131153119093), (x: 144.88, y: 240.631153119093), (x: 166.88, y: 239.631153119093), (x: 168.38, y: 246.631153119093), (x: 180.38, y: 245.131153119093), (x: 180.38, y: 232.131153119093), (x: 184.38, y: 217.131153119093), (x: 162.88, y: 202.631153119093), (x: 162.88, y: 188.631153119093), (x: 184.88, y: 182.631153119093), (x: 232.38, y: 185.131153119093), (x: 241.38, y: 255.631153119093), (x: 246.88, y: 259.131153119093), (x: 245.38, y: 308.631153119093), (x: 236.38, y: 309.631153119093), (x: 240.88, y: 413.631153119093), (x: 57.8799999999999, y: 412.131153119093), (x: 56.3799999999999, y: 403.131153119093), (x: 59.8799999999999, y: 379.131153119093), (x: 54.3799999999999, y: 319.631153119093), (x: 62.3799999999999, y: 319.631153119093), (x: 63.8799999999999, y: 257.631153119093)]
        let broome = [(x: 227.88, y: 185.131153119093), (x: 245.38, y: 306.631153119093), (x: 232.38, y: 306.631153119093), (x: 237.38, y: 414.131153119093), (x: 521.88, y: 409.131153119093), (x: 509.88, y: 380.631153119093), (x: 511.38, y: 301.131153119093), (x: 425.88, y: 298.631153119093), (x: 422.88, y: 271.631153119093), (x: 344.38, y: 273.131153119093), (x: 334.38, y: 181.631153119093)]
        let chenango = [(x: 345.38, y: 274.631153119093), (x: 419.88, y: 274.631153119093), (x: 419.88, y: 302.131153119093), (x: 512.38, y: 304.131153119093), (x: 513.88, y: 236.131153119093), (x: 519.38, y: 227.631153119093), (x: 531.38, y: 183.131153119093), (x: 549.88, y: 96.6311531190927), (x: 561.38, y: 1.13115311909269), (x: 318.88, y: 13.6311531190927)]
        let delaware = [(x: 517.38, y: 409.631153119093), (x: 506.38, y: 385.131153119093), (x: 508.88, y: 232.631153119093), (x: 545.38, y: 226.131153119093), (x: 573.88, y: 199.631153119093), (x: 612.88, y: 185.131153119093), (x: 765.38, y: 114.131153119093), (x: 828.88, y: 173.631153119093), (x: 867.88, y: 298.131153119093), (x: 899.38, y: 318.631153119093), (x: 567.38, y: 487.631153119093)]
        let monroe = [(x: 360.628408903545, y: 238.92), (x: 351.628408903545, y: 67.42), (x: 269.628408903545, y: 92.92), (x: 180.128408903545, y: 33.92), (x: 35.1284089035448, y: 3.92000000000002), (x: 33.6284089035448, y: 177.42), (x: 80.1284089035448, y: 177.42), (x: 58.6284089035448, y: 241.92), (x: 78.1284089035448, y: 240.42), (x: 80.6284089035448, y: 278.42), (x: 177.628408903545, y: 274.92), (x: 158.128408903545, y: 307.42), (x: 302.128408903545, y: 301.92), (x: 302.128408903545, y: 239.92)]
        let wayne = [(x: 354.128408903545, y: 239.42), (x: 350.628408903545, y: 68.42), (x: 488.628408903545, y: 57.92), (x: 567.628408903545, y: 72.92), (x: 690.128408903545, y: 14.92), (x: 705.628408903545, y: 249.42), (x: 474.628408903545, y: 258.92), (x: 473.128408903545, y: 240.92)]
        let steuben = [(x: 563.128408903545, y: 763.42), (x: 496.628408903545, y: 764.92), (x: 489.628408903545, y: 599.92), (x: 472.128408903545, y: 608.92), (x: 474.628408903545, y: 553.92), (x: 210.628408903545, y: 549.92), (x: 202.628408903545, y: 580.42), (x: 176.128408903545, y: 581.42), (x: 162.628408903545, y: 961.42), (x: 564.628408903545, y: 962.92)]
        let schuyler = [(x: 565.128408903545, y: 766.92), (x: 494.628408903545, y: 771.92), (x: 489.628408903545, y: 624.92), (x: 553.128408903545, y: 619.92), (x: 556.628408903545, y: 633.92), (x: 595.128408903545, y: 631.42), (x: 587.628408903545, y: 611.42), (x: 594.628408903545, y: 583.42), (x: 706.128408903545, y: 582.92), (x: 709.128408903545, y: 758.42), (x: 739.128408903545, y: 760.42), (x: 741.628408903545, y: 784.92), (x: 727.128408903545, y: 799.42), (x: 680.128408903545, y: 789.92), (x: 679.128408903545, y: 759.42)]
        let erie = [(x: 573.88, y: 511.896352583587), (x: 470.88, y: 553.896352583587), (x: 465.88, y: 545.396352583587), (x: 434.38, y: 561.896352583587), (x: 426.38, y: 555.896352583587), (x: 384.88, y: 571.896352583587), (x: 357.38, y: 551.896352583587), (x: 339.88, y: 513.396352583587), (x: 328.38, y: 510.896352583587), (x: 313.88, y: 512.396352583587), (x: 298.88, y: 501.896352583587), (x: 291.88, y: 492.396352583587), (x: 274.38, y: 495.396352583587), (x: 289.88, y: 450.396352583587), (x: 308.38, y: 418.396352583587), (x: 398.38, y: 361.396352583587), (x: 373.88, y: 305.396352583587), (x: 373.88, y: 275.396352583587), (x: 324.88, y: 235.896352583587), (x: 335.38, y: 202.396352583587), (x: 330.88, y: 189.896352583587), (x: 382.88, y: 196.396352583587), (x: 395.88, y: 212.396352583587), (x: 409.38, y: 196.896352583587), (x: 455.88, y: 175.896352583587), (x: 571.88, y: 174.896352583587), (x: 577.88, y: 310.396352583587), (x: 567.88, y: 314.896352583587), (x: 566.38, y: 356.396352583587), (x: 577.38, y: 359.896352583587)]
        let chautauqua = [(x: 315.38, y: 509.396352583587), (x: 288.38, y: 483.896352583587), (x: 275.38, y: 491.896352583587), (x: 184.38, y: 532.896352583587), (x: 2.37999999999994, y: 666.396352583587), (x: 2.87999999999994, y: 833.896352583587), (x: 313.38, y: 834.396352583587)]
        let cattaraugus = [(x: 642.38, y: 832.896352583587), (x: 312.88, y: 833.896352583587), (x: 311.38, y: 510.896352583587), (x: 325.88, y: 502.396352583587), (x: 343.38, y: 510.896352583587), (x: 365.88, y: 546.396352583587), (x: 391.38, y: 563.396352583587), (x: 462.38, y: 533.896352583587), (x: 474.88, y: 537.896352583587), (x: 511.38, y: 521.396352583587), (x: 577.38, y: 506.896352583587), (x: 577.38, y: 514.396352583587), (x: 641.38, y: 515.896352583587)]
        
        return [(name: "Manhattan", region: "newYorkCity", path: manhattan), (name: "Bronx", region: "newYorkCity", path: bronx), (name: "Kings", region: "newYorkCity", path: kings), (name: "Richmond", region: "newYorkCity", path: richmond), (name: "Dutchess", region: "midHudson", path: dutchess), (name: "Schenectady", region: "capitalDistrict", path: schenectady), (name: "Greene", region: "capitalDistrict", path: greene), (name: "Columbia", region: "capitalDistrict", path: columbia), (name: "Otsego", region: "mohawkValley", path: otsego), (name: "Franklin", region: "northCountry", path: franklin), (name: "Essex", region: "northCountry", path: essex), (name: "St. Lawrence", region: "tugHillSeaway", path: stLawrence), (name: "Jefferson", region: "tugHillSeaway", path: jefferson), (name: "Lewis", region: "tugHillSeaway", path: lewis), (name: "Oswego", region: "centralNewYork", path: oswego), (name: "Onondaga", region: "centralNewYork", path: onondaga), (name: "Tompkins", region: "southernTier", path: tompkins), (name: "Tioga", region: "southernTier", path: tioga), (name: "Broome", region: "southernTier", path: broome), (name: "Chenango", region: "southernTier", path: chenango), (name: "Delaware", region: "southernTier", path: delaware), (name: "Monroe", region: "fingerLakes", path: monroe), (name: "Wayne", region: "fingerLakes", path: wayne), (name: "Steuben", region: "fingerLakes", path: steuben), (name: "Schuyler", region: "fingerLakes", path: schuyler), (name: "Erie", region: "westernNewYork", path: erie), (name: "Chautauqua", region: "westernNewYork", path: chautauqua), (name: "Cattaraugus", region: "westernNewYork", path: cattaraugus)]
    }
    
    func getData() -> [(countyName: String, specialPopulation: Bool, geographic: Bool, facility: Bool, nativeAmerican: Bool, dentistLicenses: String, numPeople: String, under5YO: String, gte65YO: String, white: String, africanAmerican: String, americanIndian: String, asian: String, hispOrLat: String, veterans: String, foreignBorn: String, gteHS: String, ba: String, disUnder65: String, woInsuranceUnder65: String, medIncome: String, poverty: String)] {
        return [(countyName: "Manhattan", specialPopulation: true, geographic: false, facility: true, nativeAmerican: true, dentistLicenses: "2,669", numPeople: "1,643,734", under5YO: "4.9%", gte65YO: "14.9%", white: "64.6%", africanAmerican: "18%", americanIndian: "1.2%", asian: "12.8%", hispOrLat: "26%", veterans: "34,917", foreignBorn: "28.9%", gteHS: "86.6%", ba: "59.9%", disUnder65: "6%", woInsuranceUnder65: "7.9%", medIncome: "$72,871", poverty: "17.6%"),
                
                (countyName: "Bronx", specialPopulation: true, geographic: false, facility: true, nativeAmerican: false, dentistLicenses: "354", numPeople: "1,455,720", under5YO: "7.3%", gte65YO: "11.7%", white: "44.9%", africanAmerican: "43.7%", americanIndian: "2.9%", asian: "4.4%", hispOrLat: "56%", veterans: "31,029", foreignBorn: "34.4%", gteHS: "70.6%", ba: "18.9%", disUnder65: "10.2%", woInsuranceUnder65: "11.1%", medIncome: "$34,299", poverty: "30.3%"),
                
                (countyName: "Kings", specialPopulation: true, geographic: false, facility: true, nativeAmerican: false, dentistLicenses: "1,355", numPeople: "2,629,150", under5YO: "7.4%", gte65YO: "12.7%", white: "49.2%", africanAmerican: "34.6%", americanIndian: "1%", asian: "12.6%", hispOrLat: "19.2%", veterans: "44,896", foreignBorn: "37.5%", gteHS: "79.3%", ba: "32.8%", disUnder65: "5.9%", woInsuranceUnder65: "10.2%", medIncome: "$48,201", poverty: "22.3%"),
                
                (countyName: "Richmond", specialPopulation: true, geographic: false, facility: true, nativeAmerican: false, dentistLicenses: "351", numPeople: "476,015", under5YO: "5.6%", gte65YO: "15.4%", white: "76.6%", africanAmerican: "11.8%", americanIndian: "0.6%", asian: "8.8%", hispOrLat: "18.4%", veterans: "18,345", foreignBorn: "21.6%", gteHS: "88.7%", ba: "30.8%", disUnder65: "6.6%", woInsuranceUnder65: "6.4%", medIncome: "$73,197", poverty: "14.2%"),
                
                (countyName: "Dutchess", specialPopulation: true, geographic: false, facility: true, nativeAmerican: false, dentistLicenses: "201", numPeople: "294,473", under5YO: "4.6%", gte65YO: "16.4%", white: "81.6%", africanAmerican: "11.5%", americanIndian: "0.5%", asian: "3.9%", hispOrLat: "12%", veterans: "16,856", foreignBorn: "11.6%", gteHS: "89.9%", ba: "33.4%", disUnder65: "9.2%", woInsuranceUnder65: "6.2%", medIncome: "$71,904", poverty: "10.4%"),
                
                (countyName: "Schenectady", specialPopulation: true, geographic: false, facility: true, nativeAmerican: false, dentistLicenses: "105", numPeople: "154,553", under5YO: "5.9%", gte65YO: "16.3%", white: "78.9%", africanAmerican: "11.7%", americanIndian: "0.7%", asian: "4.8%", hispOrLat: "6.9%", veterans: "9,335", foreignBorn: "9.7%", gteHS: "90.5%", ba: "30.5%", disUnder65: "9.1%", woInsuranceUnder65: "5.7%", medIncome: "$58,114", poverty: "12%"),
                
                (countyName: "Greene", specialPopulation: true, geographic: false, facility: false, nativeAmerican: false, dentistLicenses: "16", numPeople: "47,508", under5YO: "4.3%", gte65YO: "20.9%", white: "89.9%", africanAmerican: "6.5%", americanIndian: "0.4%", asian: "1.1%", hispOrLat: "5.7%", veterans: "3,806", foreignBorn: "6.2%", gteHS: "86.5%", ba: "20.6%", disUnder65: "11.1%", woInsuranceUnder65: "6.9%", medIncome: "$50,278", poverty: "16.4%"),
                
                (countyName: "Columbia", specialPopulation: false, geographic: true, facility: false, nativeAmerican: false, dentistLicenses: "23", numPeople: "60,989", under5YO: "4.1%", gte65YO: "22.3%", white: "90.5%", africanAmerican: "5.1%", americanIndian: "0.3%", asian: "1.9%", hispOrLat: "4.6%", veterans: "4,705", foreignBorn: "6.1%", gteHS: "88.4%", ba: "29.3%", disUnder65: "11.4%", woInsuranceUnder65: "7.2%", medIncome: "$59,105", poverty: "13.6%"),
                
                (countyName: "Otsego", specialPopulation: true, geographic: false, facility: false, nativeAmerican: false, dentistLicenses: "30", numPeople: "60,097", under5YO: "4.2%", gte65YO: "19.7%", white: "94.3%", africanAmerican: "2.3%", americanIndian: "0.2%", asian: "1.4%", hispOrLat: "3.6%", veterans: "4,836", foreignBorn: "3.6%", gteHS: "89.9%", ba: "27.7%", disUnder65: "8.9%", woInsuranceUnder65: "6.4%", medIncome: "$48,588", poverty: "16.8%"),
                
                (countyName: "Franklin", specialPopulation: true, geographic: false, facility: true, nativeAmerican: true, dentistLicenses: "16", numPeople: "50,409", under5YO: "4.7%", gte65YO: "15.8%", white: "84.2%", africanAmerican: "6.3%", americanIndian: "7.6%", asian: "0.5%", hispOrLat: "3.4%", veterans: "3,860", foreignBorn: "3.8%", gteHS: "84.9%", ba: "17.7%", disUnder65: "11.1%", woInsuranceUnder65: "7.8%", medIncome: "$47,923", poverty: "18.3%"),
                
                (countyName: "Essex", specialPopulation: true, geographic: false, facility: true, nativeAmerican: false, dentistLicenses: "14", numPeople: "38,102", under5YO: "3.9%", gte65YO: "22.1%", white: "94.1%", africanAmerican: "3.2%", americanIndian: "0.6%", asian: "0.7%", hispOrLat: "3.4%", veterans: "3,667", foreignBorn: "3.7%", gteHS: "88.8%", ba: "24.2%", disUnder65: "11.1%", woInsuranceUnder65: "6.8%", medIncome: "$52,758", poverty: "12.2%"),
                
                (countyName: "St. Lawrence", specialPopulation: true, geographic: false, facility: true, nativeAmerican: false, dentistLicenses: "37", numPeople: "110,038", under5YO: "5.1%", gte65YO: "16.3%", white: "93.7%", africanAmerican: "2.6%", americanIndian: "1%", asian: "1.2%", hispOrLat: "2.3%", veterans: "8,001", foreignBorn: "4.4%", gteHS: "88%", ba: "22.3%", disUnder65: "10.9%", woInsuranceUnder65: "6.8%", medIncome: "$44,705", poverty: "18.5%"),
                
                (countyName: "Jefferson", specialPopulation: true, geographic: false, facility: true, nativeAmerican: false, dentistLicenses: "68", numPeople: "114,006", under5YO: "7.8%", gte65YO: "13.3%", white: "87.8%", africanAmerican: "6.8%", americanIndian: "0.6%", asian: "1.6%", hispOrLat: "7.2%", veterans: "11,024", foreignBorn: "3.9%", gteHS: "89.4%", ba: "20.7%", disUnder65: "10.1%", woInsuranceUnder65: "6.5%", medIncome: "$49,505", poverty: "14.1%"),
                
                (countyName: "Lewis", specialPopulation: false, geographic: true, facility: false, nativeAmerican: false, dentistLicenses: "5", numPeople: "26,865", under5YO: "6.2%", gte65YO: "17.6%", white: "97.2%", africanAmerican: "0.9%", americanIndian: "0.4%", asian: "0.4%", hispOrLat: "1.7%", veterans: "2,237", foreignBorn: "1.7%", gteHS: "89%", ba: "15.2%", disUnder65: "9.6%", woInsuranceUnder65: "7.1%", medIncome: "$49,819", poverty: "14%"),
                
                (countyName: "Oswego", specialPopulation: true, geographic: false, facility: true, nativeAmerican: false, dentistLicenses: "35", numPeople: "118,987", under5YO: "5.4%", gte65YO: "15.4%", white: "96.2%", africanAmerican: "1.1%", americanIndian: "0.5%", asian: "0.7%", hispOrLat: "2.5%", veterans: "8,716", foreignBorn: "1.9%", gteHS: "86.4%", ba: "17.6%", disUnder65: "11.2%", woInsuranceUnder65: "6.5%", medIncome: "$47,860", poverty: "17.4%"),
                
                (countyName: "Onondaga", specialPopulation: true, geographic: false, facility: true, nativeAmerican: false, dentistLicenses: "340", numPeople: "466,194", under5YO: "5.7%", gte65YO: "16.1%", white: "80.3%", africanAmerican: "11.8%", americanIndian: "0.9%", asian: "3.9%", hispOrLat: "4.8%", veterans: "27,970", foreignBorn: "7.4%", gteHS: "90.2%", ba: "34.1%", disUnder65: "8.7%", woInsuranceUnder65: "5.8%", medIncome: "$55,092", poverty: "14.6%"),
                
                (countyName: "Tompkins", specialPopulation: true, geographic: false, facility: false, nativeAmerican: false, dentistLicenses: "54", numPeople: "104,871", under5YO: "4.1%", gte65YO: "13.1%", white: "81%", africanAmerican: "4.3%", americanIndian: "0.4%", asian: "10.9%", hispOrLat: "5%", veterans: "4,346", foreignBorn: "12.7%", gteHS: "94.2%", ba: "50.8%", disUnder65: "7.1%", woInsuranceUnder65: "6.4%", medIncome: "$52,624", poverty: "20.1%"),
                
                (countyName: "Tioga", specialPopulation: true, geographic: false, facility: false, nativeAmerican: false, dentistLicenses: "8", numPeople: "48,760", under5YO: "5.2%", gte65YO: "18.9%", white: "96.6%", africanAmerican: "1%", americanIndian: "0.2%", asian: "0.8%", hispOrLat: "1.9%", veterans: "4,124", foreignBorn: "2.6%", gteHS: "90.9%", ba: "24.4%", disUnder65: "9%", woInsuranceUnder65: "5.4%", medIncome: "$57,514", poverty: "11.7%"),
                
                (countyName: "Broome", specialPopulation: true, geographic: false, facility: false, nativeAmerican: false, dentistLicenses: "110", numPeople: "195,334", under5YO: "5.3%", gte65YO: "18.3%", white: "86.5%", africanAmerican: "5.9%", americanIndian: "0.3%", asian: "4.5%", hispOrLat: "4.1%", veterans: "13,457", foreignBorn: "6.3%", gteHS: "89.9%", ba: "27.2%", disUnder65: "10.5%", woInsuranceUnder65: "6.4%", medIncome: "$46,261", poverty: "17.7%"),
                
                (countyName: "Chenango", specialPopulation: true, geographic: false, facility: false, nativeAmerican: false, dentistLicenses: "14", numPeople: "48,579", under5YO: "5.4%", gte65YO: "19.8%", white: "96.7%", africanAmerican: "0.9%", americanIndian: "0.4%", asian: "0.6%", hispOrLat: "2.1%", veterans: "3,676", foreignBorn: "1.8%", gteHS: "87.2%", ba: "17.4%", disUnder65: "13.5%", woInsuranceUnder65: "6.5%", medIncome: "$45,668", poverty: "14.3%"),
                
                (countyName: "Delaware", specialPopulation: true, geographic: false, facility: false, nativeAmerican: false, dentistLicenses: "9", numPeople: "45,523", under5YO: "4.1%", gte65YO: "23.3%", white: "95.2%", africanAmerican: "2%", americanIndian: "0.3%", asian: "1.1%", hispOrLat: "3.8%", veterans: "3,666", foreignBorn: "3.7%", gteHS: "87%", ba: "20.2%", disUnder65: "12.2%", woInsuranceUnder65: "7.3%", medIncome: "$43,720", poverty: "16.9%"),
                
                (countyName: "Monroe", specialPopulation: true, geographic: false, facility: true, nativeAmerican: false, dentistLicenses: "569", numPeople: "747,727", under5YO: "5.5%", gte65YO: "16.4%", white: "77%", africanAmerican: "16.2%", americanIndian: "0.4%", asian: "3.7%", hispOrLat: "8.5%", veterans: "40,325", foreignBorn: "8.3%", gteHS: "90.2%", ba: "36.2%", disUnder65: "9.2%", woInsuranceUnder65: "5.5%", medIncome: "$52,553", poverty: "14.8%"),
                
                (countyName: "Wayne", specialPopulation: true, geographic: false, facility: false, nativeAmerican: false, dentistLicenses: "36", numPeople: "90,798", under5YO: "5.4%", gte65YO: "17.5%", white: "93.7%", africanAmerican: "3.1%", americanIndian: "0.4%", asian: "0.7%", hispOrLat: "4.3%", veterans: "6,544", foreignBorn: "2.8%", gteHS: "89.6%", ba: "20.6%", disUnder65: "10.1%", woInsuranceUnder65: "6.4%", medIncome: "$50,798", poverty: "12.2%"),
                
                (countyName: "Steuben", specialPopulation: true, geographic: false, facility: false, nativeAmerican: false, dentistLicenses: "34", numPeople: "96,940", under5YO: "5.6%", gte65YO: "18.6%", white: "95%", africanAmerican: "1.6%", americanIndian: "0.3%", asian: "1.6%", hispOrLat: "1.7%", veterans: "8,965", foreignBorn: "2.4%", gteHS: "89.3%", ba: "21.3%", disUnder65: "11.8%", woInsuranceUnder65: "5.9%", medIncome: "$47,280", poverty: "15.4%"),
                
                (countyName: "Schuyler", specialPopulation: true, geographic: false, facility: false, nativeAmerican: false, dentistLicenses: "4", numPeople: "18,099", under5YO: "4.7%", gte65YO: "20.7%", white: "96.6%", africanAmerican: "1%", americanIndian: "0.3%", asian: "0.7%", hispOrLat: "1.8%", veterans: "1,687", foreignBorn: "1.6%", gteHS: "89.9%", ba: "19.5%", disUnder65: "10.4%", woInsuranceUnder65: "6.5%", medIncome: "$47,680", poverty: "12.5%"),
                
                (countyName: "Erie", specialPopulation: false, geographic: true, facility: true, nativeAmerican: false, dentistLicenses: "722", numPeople: "921,046", under5YO: "5.4%", gte65YO: "17.1%", white: "79.8%", africanAmerican: "13.9%", americanIndian: "0.7%", asian: "3.6%", hispOrLat: "5.3%", veterans: "59,885", foreignBorn: "6.7%", gteHS: "90.4%", ba: "31.6%", disUnder65: "9.2%", woInsuranceUnder65: "5.4%", medIncome: "$51,247", poverty: "15.6%"),
                
                (countyName: "Chautauqua", specialPopulation: true, geographic: true, facility: true, nativeAmerican: true, dentistLicenses: "62", numPeople: "129,504", under5YO: "5.3%", gte65YO: "18.9%", white: "93.8%", africanAmerican: "2.7%", americanIndian: "0.7%", asian: "0.7%", hispOrLat: "7.5%", veterans: "10,270", foreignBorn: "2%", gteHS: "88.2%", ba: "20.9%", disUnder65: "11.7%", woInsuranceUnder65: "6.6%", medIncome: "$42,993", poverty: "17.2%"),
                
                (countyName: "Cattaraugus", specialPopulation: false, geographic: true, facility: true, nativeAmerican: true, dentistLicenses: "27", numPeople: "77,677", under5YO: "5.8%", gte65YO: "17.9%", white: "92.2%", africanAmerican: "1.5%", americanIndian: "3.4%", asian: "0.8%", hispOrLat: "2%", veterans: "7,037", foreignBorn: "2%", gteHS: "87.9%", ba: "17.8%", disUnder65: "10.8%", woInsuranceUnder65: "7.5%", medIncome: "$42,601", poverty: "18%")]
    }
}
