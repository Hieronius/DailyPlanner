# 📝DailyPlanner

## About
An app where you can create, edit and sort tasks by the date and time. Plus you can share and import tasks with JSON file.

## 🪧Table of Contents

- [Demo](#Demo)
- [Screenshots](#Screenshots)
- [Tools/Technologies](#Tools/Technologies)
- [ToDo](#ToDo)

## 📺Demo
Part 1

https://github.com/user-attachments/assets/23171f00-968c-4677-8533-e58bad597a97

Part 2

https://github.com/user-attachments/assets/6234641c-a21f-4437-94b7-6b6fb91634b6

Part 3

https://github.com/user-attachments/assets/0e70baf1-f906-4680-80c0-c28ed4ccc18e

## 🖼Screenshots
Main Screen

<img src="https://github.com/user-attachments/assets/5c3dffc1-82f2-4343-8f2e-e325ebf56037" alt="Main Screen" width="250" />  


Detailed Screen

<img src="https://github.com/user-attachments/assets/b8735f54-4d70-4baa-a367-04c1ec7a489e" alt="Detailed Screen" width="250" />


## 🛠Tools/Technologies
- URLSession
- Realm
- UIKit
- UITableDiffableDataSource
- Dependency Injection
- XCTest
- Swift Package Manager
- MVC


## 📌ToDo
- Add more documentation
- Add more Unit Tests
- Add UI Tests
- Separate JSON Handler into different services
- Refactor CalendarGenerator to avoid using singletons
- Implement writeAsync while working with Realm operations
- Refactor custom calendar to suit better for small screen devices
- Refactor time stamp headers style for more nicer ones
- Implement logic to turn isCompleted check box of the task right in the MainScreen
- Implement logic to go back into first task of the day on the table when you back from Detailed Screen
- Create separate concurrent queue for sharing/importing notes
- Create Persistent/Network related Enum with erros for better handling

