//
//  MainViewModel.swift
//  CheoMooRac
//
//  Created by 김윤서 on 2021/09/23.
//

import Foundation

protocol MainViewModelInput {
    func refreshTableView()
    func searchResults(text: String)
    func cancelSearch()
}

protocol MainViewModelOutput {
    var items:  Dynamic<[Person]> {get}
    var nowRefreshing: Dynamic<Bool> {get}
    var isFiltering: Dynamic<Bool> {get}
    
    var sectionHeaderList: [String] {get}
    func getSectionPersonArray(at section: Int) -> [Person]
}

protocol MainViewModelProtocol : MainViewModelInput, MainViewModelOutput {
    var input : MainViewModelInput { get }
    var output : MainViewModelOutput { get }
}

class MainViewModel: MainViewModelProtocol {
    var input: MainViewModelInput { return self }
    var output: MainViewModelOutput { return self }
    
    //  MARK: - INPUT
    func refreshTableView() {
        if !nowRefreshing.value {
            nowRefreshing.value = true
            //refreshing logic
            nowRefreshing.value = false
        }
    }
    
    func searchResults(text: String) {
        if text.isEmpty {
            isFiltering.value = false
            setTableView()
        } else {
            self.sectionHeaderList.removeAll()
            self.items.value.removeAll()
            
            isFiltering.value = true
            
            let filteredArr = data.filter { ($0.familyName+$0.firstName).localizedCaseInsensitiveContains(text) }
            
            var filterdHeaderList$: [String] = []
            filteredArr.forEach {
                filterdHeaderList$.append(StringManager.shared.chosungCheck(word: ($0.familyName+$0.firstName)))
            }
            
            filterdHeaderList$ = Array(Set(filterdHeaderList$)).sorted()
            filteredData = filteredArr
            items.value = filteredData
            sectionHeaderList = filterdHeaderList$
        }
    }
    
    func cancelSearch() {
        setTableView()
        isFiltering.value = false
    }

   //  MARK: - OUTPUT
    let items: Dynamic<[Person]> = Dynamic([])
    let nowRefreshing: Dynamic<Bool> = Dynamic(false)
    let isFiltering: Dynamic<Bool> = Dynamic(false)
    
    func getSectionArray(at section: Int) -> [String]  {
        return sectionArray(at: section, data: isFiltering.value ? self.filteredData : self.data)
    }
    
    func getSectionPersonArray(at section: Int) -> [Person]  {
        return sectionArrayPerson(at: section, data: isFiltering.value ? self.filteredData : self.data)
    }
    
    var sectionHeaderList: [String] = []
    
    
    init() {
      setTableView()
    }
    
    //  MARK: - Properties
    
    private var filteredData: [Person] = []
    
    private var data =  [Person(firstName: "윤서", familyName: "김", phoneNumber: "010-6515-6030"),
                         Person(firstName: "루희", familyName: "김", phoneNumber: "010-6515-6030"),
                         Person(firstName: "예지", familyName: "윤", phoneNumber: "010-6515-6030"),
                         Person(firstName: "혜수", familyName: "김", phoneNumber: "010-6515-6030"),
                         Person(firstName: "리헤이", familyName: "", phoneNumber: "010-6515-6030"),
                         Person(firstName: "제", familyName: "노", phoneNumber: "010-6515-6030"),
                         Person(firstName: "엠마", familyName: "", phoneNumber: "010-6515-6030"),
                         Person(firstName: "모아나", familyName: "", phoneNumber: "010-6515-6030"),
                         Person(firstName: "민재", familyName: "곽", phoneNumber: "010-6515-6030"),
                         Person(firstName: "케이데이", familyName: "", phoneNumber: "010-6515-6030"),
                         Person(firstName: "가비", familyName: "", phoneNumber: "010-6515-6030"),
                         Person(firstName: "시미즈", familyName: "", phoneNumber: "010-6515-6030"),
                         Person(firstName: "호동", familyName: "강", phoneNumber: "010-6515-6030"),
                         Person(firstName: "재석", familyName: "유", phoneNumber: "010-6515-6030"),
                         Person(firstName: "리정", familyName: "", phoneNumber: "010-6515-6030"),
                         Person(firstName: "몬익화", familyName: "", phoneNumber: "010-6515-6030"),
                         Person(firstName: "코코", familyName: "", phoneNumber: "010-6515-6030"),
                         Person(firstName: "잼권", familyName: "", phoneNumber: "010-6515-6030")
                         
      ]
    
    private func setTableView() {
        self.items.value = data
        var sectionHeaderList$: [String] = []
        self.items.value.forEach { person in
            sectionHeaderList$.append(StringManager.shared.chosungCheck(word: person.familyName + person.firstName))
        }
        self.sectionHeaderList = Array(Set(sectionHeaderList$)).sorted()
    }
    
    private func sectionArray(at section: Int, data: [Person]) -> [String] {
        let list = data.filter {
            return StringManager.shared.chosungCheck(word: $0.familyName + $0.firstName) == sectionHeaderList[section-1]
        }.map { person in
            return person.familyName + person.firstName
        }
        return list
    }
    
    private func sectionArrayPerson(at section: Int, data: [Person]) -> [Person] {
        let list = data.filter {
            return StringManager.shared.chosungCheck(word: $0.familyName + $0.firstName) == sectionHeaderList[section-1]
        }
        return list
    }

}
