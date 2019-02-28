

import UIKit

public struct PopoverSection {
    let title: String
    let items: [PopoverItem]
    var expanded: Bool
    init(_ title:String,_ items:[PopoverItem],_ expanded:Bool = false) {
        self.title = title
        self.items = items
        self.expanded = expanded
    }
    static func clearFilters() -> PopoverSection {
        return PopoverSection("Clear Filters", [])
    }
}

public struct PopoverItem {
    let text: String
    var selected: Bool
    init(_ text:String) {
        self.text = text
        self.selected = false
    }
    init(_ text:String,_ selected:Bool){
        self.text = text
        self.selected = selected
    }
}


struct SelectedFilterItem {
    let indexPath:IndexPath
    let section:String
    let item:String
    let cleared:Bool
    init(_ indexPath:IndexPath,_ section:String,_ item:String){
        self.indexPath = indexPath
        self.section = section
        self.item = item
        self.cleared = false
    }
    init(cleared:Bool){
        self.indexPath = IndexPath(row: 0, section: 0)
        self.section = ""
        self.item = ""
        self.cleared = true
    }
}


//: MARK: - FilterItemSelectable -
 //
protocol FilterItemSelectable: class {
    func filterItemSelected(_ filterItem:SelectedFilterItem)
}


//: MARK: - PopoverTableView -
final class PopoverTableView: UIViewController {
    lazy var tableView: UITableView = self.lazyTableView()
    var selectedIndexPaths: [IndexPath] = [] {
        didSet {
            enableSelectedIndexPaths()
        }
    }
    var collapsed: Bool = false {
        didSet {
            dataSource = dataSource.map({
                PopoverSection($0.title, $0.items, collapsed)
            })
        }
    }
    var sectionTitles: [String] = []
    fileprivate var dataSource: [PopoverSection] = []
    weak var selectedFilterItemDelegate: FilterItemSelectable?
    required init?(coder aDecoder: NSCoder) {fatalError()}
    init(_ dataSource:[PopoverSection]) {
        super.init(nibName: nil, bundle: nil)
        self.dataSource = dataSource
        self.sectionTitles = dataSource.map({$0.title})
        selfInit()
    }
}



extension PopoverTableView: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44.0
    }
    
    // Header
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            let clearHeader = tableView.dequeueReusableHeaderFooterView(withIdentifier: ClearFiltersTableViewHeader.identifier) as? ClearFiltersTableViewHeader ?? ClearFiltersTableViewHeader(reuseIdentifier: ClearFiltersTableViewHeader.identifier)
            clearHeader.delegate = self
            clearHeader.filterCount = selectedIndexPaths.count
            return clearHeader
        } else {
            let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: ExpandableTableViewHeader.identifier) as? ExpandableTableViewHeader ?? ExpandableTableViewHeader(reuseIdentifier: ExpandableTableViewHeader.identifier)
            header.titleLabel.text = sectionTitles[section]
            header.setExpanded(dataSource[section].expanded)
            header.section = section
            header.delegate = self
            return header
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        cellSelected(indexPath)
        selectedIndexPaths.append(indexPath)
        
        let originalSectionTitle = dataSource[indexPath.section].title
        let sectionCounts = selectedIndexPaths.filter({$0.section == indexPath.section}).count
        sectionTitles[indexPath.section] = "\(originalSectionTitle)\((sectionCounts == 0) ? "" : " (\(sectionCounts))")"
        
        if let clearHeader = tableView.headerView(forSection: 0) as? ClearFiltersTableViewHeader {
            clearHeader.filterCount += 1
        }
        
    }
    
    
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        cellSelected(indexPath)
        
        if let selectedIndex = selectedIndexPaths.indexOf(indexPath) {
            selectedIndexPaths.remove(at: selectedIndex)
        }
        
        let originalSectionTitle = dataSource[indexPath.section].title
        let sectionCounts = selectedIndexPaths.filter({$0.section == indexPath.section}).count
        sectionTitles[indexPath.section] = "\(originalSectionTitle)\((sectionCounts == 0) ? "" : " (\(sectionCounts))")"
        if let filterHeader = tableView.headerView(forSection: indexPath.section) as? ExpandableTableViewHeader {
            filterHeader.updateFilterTitle(sectionTitles[indexPath.section])
        }
        
        if let clearHeader = tableView.headerView(forSection: 0) as? ClearFiltersTableViewHeader {
            clearHeader.filterCount -= 1
        }
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if selectedIndexPaths.contains(indexPath) {
            tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
        }
    }
    
    //: MARK: - cellSelected -
    func cellSelected(_ indexPath:IndexPath){
        let selectedFilterItem = SelectedFilterItem(indexPath,dataSource[indexPath.section].title, dataSource[indexPath.section].items[indexPath.row].text)
        selectedFilterItemDelegate?.filterItemSelected(selectedFilterItem)
    }
    
}


extension PopoverTableView: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource[section].expanded ? 0 : dataSource[section].items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:PopoverExpandableCell.identifier, for: indexPath) as! PopoverExpandableCell
        let item: PopoverItem = dataSource[indexPath.section].items[indexPath.row]
        cell.configureCell(item)
        return cell
    }
}


// MARK: - Section Header Delegate
extension PopoverTableView: ExpandableTableViewHeaderDelegate, ClearFiltersTableViewHeaderDelegate  {
    
    func toggleSection(_ header: ExpandableTableViewHeader, section: Int) {
        let expanded = !dataSource[section].expanded
        dataSource[section].expanded = expanded
        header.setExpanded(expanded)
        // reveal the collapse Index Paths
        tableView.reloadSections(IndexSet(integer: section), with: .automatic)
        if !expanded {
            if !selectedIndexPaths.isEmpty {
                tableView.beginUpdates()
                selectedIndexPaths
                    .filter({$0.section == section})
                    .forEach({tableView.selectRow(at: $0, animated: false, scrollPosition: .none)})
                tableView.endUpdates()
            }
        }
    }
    
    func clearFilters(_ header: ClearFiltersTableViewHeader) {
        selectedIndexPaths = []
        selectedFilterItemDelegate?.filterItemSelected(SelectedFilterItem(cleared: true))
        
        (0..<dataSource.count).forEach({
            let popoverSection = dataSource[$0]
            sectionTitles[$0] = popoverSection.title
        })
        
        tableView.reloadData()
        header.animateSelection()
    }
    
    func enableSelectedIndexPaths(){
        if !selectedIndexPaths.isEmpty {
            tableView.beginUpdates()
            selectedIndexPaths.forEach({tableView.selectRow(at: $0, animated: false, scrollPosition: .none)})
            tableView.endUpdates()
            
            (0..<sectionTitles.count).forEach({
                let index = $0
                let popoverSection = dataSource[index]
                let originalSectionTitle = popoverSection.title
                let sectionCounts = selectedIndexPaths.filter({$0.section == index}).count
                let modifiedHeaderTitle = (sectionCounts == 0) ? "" : " (\(sectionCounts))"
                sectionTitles[index] = "\(originalSectionTitle)\(modifiedHeaderTitle)"
                if let filterHeader = tableView.headerView(forSection: index) as? ExpandableTableViewHeader {
                    filterHeader.updateFilterTitle("\(originalSectionTitle)\(modifiedHeaderTitle)")
                }
            })
        }
    }
}

//: MARK: - UI SETUP -
extension PopoverTableView {
    
    fileprivate func lazyTableView() -> UITableView {
        let tv = UITableView(frame: .zero, style: .plain)
        tv.register(PopoverExpandableCell.self, forCellReuseIdentifier:PopoverExpandableCell.identifier)
        tv.register(ClearFiltersTableViewHeader.self, forHeaderFooterViewReuseIdentifier:ClearFiltersTableViewHeader.identifier)
        tv.register(ExpandableTableViewHeader.self, forHeaderFooterViewReuseIdentifier: ExpandableTableViewHeader.identifier)
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.dataSource = self
        tv.delegate = self
        tv.allowsMultipleSelection = true
        tv.rowHeight = UITableView.automaticDimension
        tv.estimatedRowHeight = 85.0
        return tv
    }
    
    fileprivate func selfInit(){
        view.addSubview(tableView)
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
}



//: MARK: - Header -
protocol ExpandableTableViewHeaderDelegate {
    func toggleSection(_ header: ExpandableTableViewHeader, section: Int)
}

final class ExpandableTableViewHeader: UITableViewHeaderFooterView {
    static let identifier = "expandableHeaderCell"
    var delegate: ExpandableTableViewHeaderDelegate?
    var section: Int = 0
    let titleLabel = UILabel()
    let indicatorImageView = UIImageView(image: AppTheme.Image.whiteChevronLeft)
    required init?(coder aDecoder: NSCoder) {fatalError()}
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = AppTheme.Colors.darkGrey
        contentView.addSubview(titleLabel)
        contentView.addSubview(indicatorImageView)
        // Indicator
        indicatorImageView.translatesAutoresizingMaskIntoConstraints = false
        indicatorImageView.widthAnchor.constraint(equalToConstant: 16).isActive = true
        indicatorImageView.heightAnchor.constraint(equalTo: indicatorImageView.widthAnchor, multiplier: 1.0).isActive = true
        // Title label
        titleLabel.textAlignment = .left
        titleLabel.font = UIFont.preferredFont(forTextStyle: .body)
        titleLabel.textColor = .white
        titleLabel.numberOfLines = 0
        titleLabel.lineBreakMode = .byWordWrapping
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        // Layout
        let marginGuide = contentView.layoutMarginsGuide
        titleLabel.leadingAnchor.constraint(equalTo: marginGuide.leadingAnchor).isActive = true
        titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        let trailingConstraint = titleLabel.trailingAnchor.constraint(equalTo: indicatorImageView.leadingAnchor)
        trailingConstraint.priority = UILayoutPriority(rawValue: 999.0)
        trailingConstraint.isActive = true
        let bottomConstraint = titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        bottomConstraint.priority = UILayoutPriority(rawValue: 999.0)
        bottomConstraint.isActive = true
        indicatorImageView.trailingAnchor.constraint(equalTo: marginGuide.trailingAnchor).isActive = true
        indicatorImageView.centerYAnchor.constraint(equalTo: marginGuide.centerYAnchor).isActive = true
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(ExpandableTableViewHeader.tapHeader(_:))))
    }
    
    // Trigger toggle section when tapping on the header
    @objc func tapHeader(_ gestureRecognizer: UITapGestureRecognizer) {
        guard let cell = gestureRecognizer.view as? ExpandableTableViewHeader else {return}
        delegate?.toggleSection(self, section: cell.section)
    }
    
    func updateFilterTitle(_ newTitle:String){
        UIView.animate(withDuration: 0.2) {
            self.titleLabel.text = newTitle
        }
    }
    
    func setExpanded(_ expanded: Bool) {
        UIView.animate(withDuration: 0.2) {
            self.indicatorImageView.image = expanded ? AppTheme.Image.whiteChevronLeft : AppTheme.Image.whiteChevronDown
        }
    }
}


//: MARK: - PopoverExpandableCell -
final class PopoverExpandableCell: UITableViewCell {
    static let identifier = "popoverCell"
    let titleLabel = UILabel()
    let expandedLabel = UILabel()
    required init?(coder aDecoder: NSCoder) {fatalError()}
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .value2, reuseIdentifier: reuseIdentifier)
        let marginGuide = contentView.layoutMarginsGuide
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textAlignment = .left
        titleLabel.font = UIFont.preferredFont(forTextStyle: .body)
        titleLabel.setContentHuggingPriority(UILayoutPriority.defaultHigh, for: .vertical)
        titleLabel.numberOfLines = 0
        titleLabel.lineBreakMode = .byWordWrapping
        if #available(iOS 10.0, *) {titleLabel.adjustsFontForContentSizeCategory = true}
        // Add Labels
        contentView.addSubview(titleLabel)
        titleLabel.leadingAnchor.constraint(equalTo: marginGuide.leadingAnchor).isActive = true
        titleLabel.topAnchor.constraint(equalTo: marginGuide.topAnchor).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: marginGuide.trailingAnchor).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: marginGuide.bottomAnchor).isActive = true
    }
    public func configureCell(_ item:PopoverItem){
        titleLabel.text = item.text
    }
}


//: MARK: - ClearFilters -
protocol ClearFiltersTableViewHeaderDelegate: class {
    func clearFilters(_ header: ClearFiltersTableViewHeader)
}

final class ClearFiltersTableViewHeader: UITableViewHeaderFooterView {
    static let identifier = "clearHeaderCell"
    weak var delegate: ClearFiltersTableViewHeaderDelegate?
    let clearLabel = UILabel()
    var filterCount: Int = 0 {
        didSet {
            let text = (filterCount == 0) ? "Filters" : "Clear Filters (\(filterCount))"
            let backgroundColor: UIColor = (filterCount == 0) ? AppTheme.Colors.darkGrey : .red
            UIView.animate(withDuration: 0.2) {
                self.clearLabel.text = text
                self.contentView.backgroundColor = backgroundColor
            }
        }
    }
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = AppTheme.Colors.darkGrey
        contentView.addSubview(clearLabel)
        clearLabel.textAlignment = .center
        clearLabel.font = UIFont(descriptor: UIFont.preferredFont(forTextStyle: .body).fontDescriptor.withSymbolicTraits(.traitBold)!, size: 0)
        clearLabel.textColor = .white
        clearLabel.text = "Filters"
        clearLabel.numberOfLines = 0
        clearLabel.lineBreakMode = .byWordWrapping
        clearLabel.translatesAutoresizingMaskIntoConstraints = false
        let marginGuide = contentView.layoutMarginsGuide
        clearLabel.leadingAnchor.constraint(equalTo: marginGuide.leadingAnchor).isActive = true
        clearLabel.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        clearLabel.trailingAnchor.constraint(equalTo: marginGuide.trailingAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: clearLabel.bottomAnchor).isActive = true
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(ClearFiltersTableViewHeader.tapHeader(_:))))
    }
    required init?(coder aDecoder: NSCoder) {fatalError()}
    @objc func tapHeader(_ gestureRecognizer: UITapGestureRecognizer) {
        guard ((gestureRecognizer.view as? ClearFiltersTableViewHeader) != nil) else {return}
        delegate?.clearFilters(self)
    }
    func animateSelection(){
        UIView.animate(withDuration: 0.2, animations: {
            self.contentView.alpha = 0.3
            self.filterCount = 0
            self.clearLabel.text = "Filters"
        }) { (complete) in
            UIView.animate(withDuration: 0.2, animations: {
                self.contentView.alpha = 1.0
            })
        }
    }
}
