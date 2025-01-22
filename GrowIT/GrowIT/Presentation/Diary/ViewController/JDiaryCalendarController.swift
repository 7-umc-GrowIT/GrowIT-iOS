//
//  TestViewController.swift
//  GrowIT
//
//  Created by 허준호 on 1/19/25.
//

import UIKit
import Then
import SnapKit

class JDiaryCalendarController: UIViewController {
    private lazy var jDiaryCalendar = JDiaryCalendar()
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = jDiaryCalendar
        view.backgroundColor = .white
        
        currentMonthIndex = currentCalendar.component(.month, from: currentDate) - 1
        currentYear = currentCalendar.component(.year, from: currentDate)
        
        jDiaryCalendar.calendarCollectionView.delegate = self
        jDiaryCalendar.calendarCollectionView.dataSource = self
        jDiaryCalendar.backMonthBtn.addTarget(self, action: #selector(backMonthTapped), for: .touchUpInside)
        jDiaryCalendar.nextMonthBtn.addTarget(self, action: #selector(nextMonthTapped), for: .touchUpInside)
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
        jDiaryCalendar.calendarCollectionView.reloadData()
    }
    
    func isLeapYear() -> Bool { //윤달 계산
        let year = currentCalendar.component(.year, from: currentDate)
        return (year % 4 == 0 && year % 100 != 0) || year % 400 == 0
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
        
        
        // Adjust day number based on the first day of the month
        if day < 1 {
            // 이전 달의 날짜를 표시
            cell.figure(day: previousMonthDay, isSunday: false, isFromCurrentMonth: false)
            cell.isHidden = false
        } else if day > numberOfDaysInMonth {
            // 다음 달의 날짜를 표시
            cell.figure(day: day - numberOfDaysInMonth, isSunday: false, isFromCurrentMonth: false)
            cell.isHidden = false
        } else {
            // 현재 달의 날짜를 표시
            let weekdayIndex = (firstDayIndex + day - 1) % 7
            if weekdayIndex == 0 { // 일요일
                cell.figure(day: day, isSunday: true, isFromCurrentMonth: true)
            } else {
                cell.figure(day: day, isSunday: false, isFromCurrentMonth: true)
            }
            cell.isHidden = false
        }
        
        
        return cell
    }
    
func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //let paddingSpace = 16 * 2 // 좌우 패딩
        let availableWidth = collectionView.frame.width
        let widthPerItem = availableWidth / 7
        
        return CGSize(width: widthPerItem, height: widthPerItem) // 셀의 너비와 높이를 동일하게 설정
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0) // 섹션의 여백 설정
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0 // 줄 간의 간격
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0 // 항목 간 간격
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader else {
            fatalError("Unexpected element kind")
        }
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: JWeekDayHeaderView.reuseIdentifier, for: indexPath) as! JWeekDayHeaderView
        return header
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 52) // 적절한 헤더 높이 설정
    }
    
}
