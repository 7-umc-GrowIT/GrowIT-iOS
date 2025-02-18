//
//  TestViewController.swift
//  GrowIT
//
//  Created by 허준호 on 1/19/25.
//

import UIKit
import Then
import SnapKit

protocol JDiaryCalendarControllerDelegate: AnyObject {
    func didSelectDate(_ date: String)
}

class JDiaryCalendarController: UIViewController {
    private lazy var jDiaryCalendar = JDiaryCalendar()
    private lazy var diaryService = DiaryService()
    private lazy var callendarDiaries : [DiaryDateDTO] = []
    private var numberOfWeeksInMonth = 0  // 주 수를 저장하는 변수
    private var cellWidth: Double = 0
    private lazy var isDark: Bool = false
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        return formatter
    }()
    
    weak var delegate: JDiaryCalendarControllerDelegate?
    
    var daysPerMonth: [Int] {
        return [31, isLeapYear() ? 29 : 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31] // 윤년 고려
    }
//    var currentMonthIndex: Int = 1
//    var currentYear: Int = 2025
    var currentDate = Date()
    var currentCalendar: Calendar {
        var calendar = Calendar.current
        calendar.firstWeekday = 1 // 일요일 시작
        return calendar
    }
    
    var currentMonthIndex : Int?

    var currentYear: Int?
    
    var numberOfDaysInMonth: Int {
        return daysPerMonth[currentMonthIndex!]
    }
    
    var firstWeekdayOfMonth: Int {
        var components = DateComponents()
        components.year = currentYear
        components.month = currentMonthIndex! + 1
        components.day = 1
        
        let calendar = Calendar.current
        let date = calendar.date(from: components)!
        return calendar.component(.weekday, from: date)
    }
    
    private let isDropDown: Bool
    
    init(isDropDown: Bool){
        self.isDropDown = isDropDown
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getDiaryDates()
        jDiaryCalendar.calendarCollectionView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = jDiaryCalendar
        view.backgroundColor = .clear
        
        currentMonthIndex = currentCalendar.component(.month, from: currentDate) - 1
        currentYear = currentCalendar.component(.year, from: currentDate)
        
        jDiaryCalendar.calendarCollectionView.delegate = self
        jDiaryCalendar.calendarCollectionView.dataSource = self
        jDiaryCalendar.backMonthBtn.addTarget(self, action: #selector(backMonthTapped), for: .touchUpInside)
        jDiaryCalendar.nextMonthBtn.addTarget(self, action: #selector(nextMonthTapped), for: .touchUpInside)
        
        //getDiaryDates()
    }
    
    
    
    func refreshData(){
        getDiaryDates()
        
    }
    
    private func getDiaryDates(){
        diaryService.fetchDiaryDates(year: currentYear!, month: currentMonthIndex! + 1, completion: { [weak self] result in
            guard let self = self else {return}
            switch result{
            case.success(let data):
                self.callendarDiaries.removeAll()
                data?.diaryDateList.forEach{
                    self.callendarDiaries.append($0)
                }
                self.updateCalendar()
            case.failure(let error):
                print("Error: \(error)")
            }
        })
    }
    
    func configureTheme(isDarkMode: Bool) {
        if isDarkMode {
            isDark = true
            jDiaryCalendar.onDarkMode()
        } else {
            isDark = false
        }
    }
    
    @objc private func backMonthTapped() {
        if currentMonthIndex == 0 {
            currentMonthIndex = 11 // 12월로 설정
            currentYear! -= 1 // 연도 감소
        } else {
            currentMonthIndex! -= 1
        }
        updateCalendar()
    }
    
    @objc private func nextMonthTapped() {
        if currentMonthIndex == 11 {
            currentMonthIndex = 0 // 1월로 설정
            currentYear! += 1 // 연도 증가
        } else {
            currentMonthIndex! += 1
        }
        updateCalendar()
    }
    
    private func updateCalendar() {
        jDiaryCalendar.yearMonthLabel.text = "\(currentYear!)년 \(currentMonthIndex! + 1)월"
        calculateWeeksInMonth()
        adjustCalendarHeightBasedOnWeeks()
        jDiaryCalendar.calendarCollectionView.reloadData()
        self.view.layoutIfNeeded()
    }
    
//    private func adjustCalendarHeightBasedOnWeeks() {
//        // 셀 높이 계산 (예: 각 셀의 높이가 collectionView의 width / 7)
//        let cellHeight = jDiaryCalendar.calendarCollectionView.frame.width / 7
//        
//        // 전체 높이 계산 (주의 수 * 셀 높이 + 필요한 패딩 또는 섹션 헤더 높이)
//        let totalHeight = CGFloat(numberOfWeeksInMonth) * cellHeight + 12 + 32 + 12 // 여기서 12, 32, 12는 추가 패딩을 가정한 값입니다.
//        
//        jDiaryCalendar.calendarBg.snp.updateConstraints { make in
//            make.height.equalTo(totalHeight)
//        }
//        view.layoutIfNeeded() // 레이아웃 업데이트를 위해 호출
//    }
    
    func isLeapYear() -> Bool { //윤달 계산
        let year = currentCalendar.component(.year, from: currentDate)
        return (year % 4 == 0 && year % 100 != 0) || year % 400 == 0
    }
    
    private func calculateWeeksInMonth() {
        let daysInMonth = numberOfDaysInMonth
        let daysToShowFromPrevMonth = (firstWeekdayOfMonth - currentCalendar.firstWeekday + 7) % 7
        let totalDays = daysToShowFromPrevMonth + daysInMonth
        numberOfWeeksInMonth = (totalDays + 6) / 7  // 계산된 총 일수를 7로 나누어 주 수 계산
    }

    private func adjustCalendarHeightBasedOnWeeks() {
        let totalHeight = CGFloat(numberOfWeeksInMonth) * cellWidth + 88
        jDiaryCalendar.calendarBg.snp.updateConstraints { make in
            make.height.equalTo(totalHeight)
        }
        view.layoutIfNeeded()  // 즉시 레이아웃을 업데이트하여 변경 사항 적용
    }
    
    
}

extension JDiaryCalendarController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        let firstDayOfMonth = firstWeekdayOfMonth // 현재월의 시작
        let daysInPreviousMonth = daysPerMonth[(currentMonthIndex! + 11) % 12]  // 이전 달의 날짜 수
        let daysToShowFromPrevMonth = (firstDayOfMonth - currentCalendar.firstWeekday + 7) % 7
        
        let daysInMonth = numberOfDaysInMonth
        let totalDays = daysToShowFromPrevMonth + daysInMonth
        
        let extraDaysToShow = 7 - totalDays % 7
        return totalDays + (extraDaysToShow == 7 ? 0 : extraDaysToShow)  // 다음 달의 추가 날짜
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: JDiaryCell.identifier, for: indexPath) as? JDiaryCell else { return UICollectionViewCell()}
        let firstDayIndex = firstWeekdayOfMonth - 1  // 0-based index
        let day = indexPath.item - firstDayIndex + 1
        
        let daysInPreviousMonth = daysPerMonth[(currentMonthIndex! + 11) % 12] // 이전 달의 날짜 수
        let daysToShowFromPreviousMonth = firstWeekdayOfMonth - currentCalendar.firstWeekday
        let previousMonthDay = daysInPreviousMonth + day
        
        let previousMonth = currentMonthIndex! == 0 ? 12 : currentMonthIndex!
        let nextMonth = currentMonthIndex! == 11 ? 1 : currentMonthIndex! + 2
        let yearAdjustmentPrevious = currentMonthIndex! == 0 ? -1 : 0
        let yearAdjustmentNext = currentMonthIndex! == 11 ? 1 : 0

        var dateComponents = DateComponents()
        dateComponents.year = currentYear
        dateComponents.month = currentMonthIndex! + 1

        // Adjust day number based on the first day of the month
        if day < 1 {
            // 이전 달의 날짜를 표시
            cell.figure(day: previousMonthDay, isSunday: false, isFromCurrentMonth: false, isDark: self.isDark)
            cell.isHidden = false
            
            dateComponents.month = previousMonth
            dateComponents.year! += yearAdjustmentPrevious
            dateComponents.day = daysPerMonth[previousMonth - 1] + day + 1
        } else if day > numberOfDaysInMonth {
            // 다음 달의 날짜를 표시
            cell.figure(day: day - numberOfDaysInMonth, isSunday: false, isFromCurrentMonth: false, isDark: self.isDark)
            cell.isHidden = false
            
            dateComponents.month = nextMonth
            dateComponents.year! += yearAdjustmentNext
            dateComponents.day = day - numberOfDaysInMonth + 1
        } else {
            // 날짜 계산
            dateComponents.day = day + 1
            
            // 현재 달의 날짜를 표시
            
            let weekdayIndex = (firstDayIndex + day - 1) % 7
            if weekdayIndex == 0 { // 일요일
                cell.figure(day: day, isSunday: true, isFromCurrentMonth: true, isDark: self.isDark)
            } else {
                cell.figure(day: day, isSunday: false, isFromCurrentMonth: true, isDark: self.isDark)
            }
            cell.isHidden = false
        }
        
        let date = currentCalendar.date(from: dateComponents)!
            let dateString = dateFormatter.string(from: date)
        
        if let _ = callendarDiaries.first(where: { $0.date == dateString }) {
            print(dateString)
            cell.showIcon(isShow: true) // 해당 날짜에 일기가 있다면 아이콘 표시
        }else {
            cell.showIcon(isShow: false)// 아니면 숨김
        }
        
        
        return cell
    }
    
func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //let paddingSpace = 16 * 2 // 좌우 패딩
        let availableWidth = collectionView.frame.width
        let widthPerItem = availableWidth / 7
        cellWidth = widthPerItem
    
        return CGSize(width: widthPerItem, height: widthPerItem) // 셀의 너비와 높이를 동일하게 설정
    }
    
    /// 섹션 여백
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0) // 섹션의 여백 설정
    }
    /// 줄 간격
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0 // 줄 간의 간격
    }
    /// 셀 간격
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0 // 항목 간 간격
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader else {
            fatalError("Unexpected element kind")
        }
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: JWeekDayHeaderView.reuseIdentifier, for: indexPath) as! JWeekDayHeaderView
        
        header.configureTheme(isDarkMode: self.isDark)
        return header
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 32) // 적절한 헤더 높이 설정
    }
    
    /// 셀 선택 시 실행되는 메소드
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let firstDayIndex = firstWeekdayOfMonth - 1  // 월의 첫 요일 인덱스 계산
        let day = indexPath.item - firstDayIndex + 1
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd" // 날짜 형식 지정
        
        var dateComponents = DateComponents()
        dateComponents.year = currentYear
        
        // 달력에서 셀의 날짜 계산
        if day < 1 {
            // 이전 달
            dateComponents.month = currentMonthIndex == 0 ? 12 : currentMonthIndex
            let daysInPreviousMonth = daysPerMonth[(currentMonthIndex! + 11) % 12]
            dateComponents.day = daysInPreviousMonth + day
            dateComponents.year! -= currentMonthIndex == 0 ? 1 : 0
        } else if day > numberOfDaysInMonth {
            // 다음 달
            dateComponents.month = currentMonthIndex == 11 ? 1 : currentMonthIndex! + 2
            dateComponents.day = day - numberOfDaysInMonth
            dateComponents.year! += currentMonthIndex == 11 ? 1 : 0
        } else {
            // 현재 달
            dateComponents.month = currentMonthIndex! + 1
            dateComponents.day = day
        }
        

        if let date = Calendar.current.date(from: dateComponents) {
            let formattedDate = dateFormatter.string(from: date)
            
            if let result = callendarDiaries.first(where: {$0.date == formattedDate}){
                print("selectedDiaryId: \(result.diaryId)")
                print("🐾isDropDown값은 \(self.isDropDown)")
                if(self.isDropDown){
                    CustomToast(containerWidth: 310).show(image: UIImage(named: "toastAlertIcon") ?? UIImage(), message: "해당 날짜는 이미 일기를 작성했어요", font: .heading3SemiBold())
                }else{
                    diaryService.fetchDiary(diaryId: result.diaryId, completion: { [weak self] result in
                        guard let self = self else {return}
                        switch result{
                        case.success(let data):
                            let diaryPostFixVC = DiaryPostFixViewController(text: data.content, date: data.date, diaryId: data.diaryId)
                            diaryPostFixVC.modalPresentationStyle = .fullScreen
                            diaryPostFixVC.onDismiss = { [weak self] in
                                self?.getDiaryDates()
                            }
                            presentPageSheet(viewController: diaryPostFixVC, detentFraction: 0.65)
                        case.failure(let error):
                            print("Error: \(error)")
                        }
                    })
                    delegate?.didSelectDate(formattedDate)
                }
            }
            print("Selected date: \(formattedDate)")
        }
    }
    
}

extension Notification.Name {
    static let deleteDiary = Notification.Name("deleteDiary")
}
