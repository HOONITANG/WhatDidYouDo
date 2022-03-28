# WhatDidYouDoToday

# **💡 Background**

하루를 열심히 보냈는데 막상 오늘 뭐했지? 라는 생각이 많이들어서 만들게 된 앱

### **목적 및 계기**

- 하루를 어떻게 보냈는지 체계적으로 관리하기위해 만들게 됨.
- 오늘 해야하는 일은 무엇이고, 어제 안 한 일이 무엇인지 관리 할 수 있으면 좋을 것 같아서 만들게 됨.
- 어떤 일에 내가 얼마나 투자했는지 알 수 있는 앱을 만들고자 함.

---

# **🛠 Development**

- Back-end

BackEnd에 해당하는 부분은 없습니다.

- Front-end

Swift를 사용했고, 라이브러리는 Realm, Firebase/RemoteConfig, Google-Mobile-Ads-SDK,  FSCalendar, RandomColorSwift을 사용함.

파일구조

 - View 
 - ViewModel 
 - Model 
 - Controller 
 - Service
 - Utils 
 - I18NStrings 
 - Localizable.strings

- View:
    - Controller에서 사용되는 TableView의 Cell, CollectionView의 Cell, CustomView 등 View와 관련된 파일을 관리합니다.
- ViewModel:
    - View와 Controller 사이에서 data전달 역할과 view에보여지는 data 가공 작업을 담당하는 파일을 관리합니다.
- Model:
    - realm에 저장된 데이터를 관리합니다.
- Controller:
    - realm data를 View와 연결하는 부분과 클릭, swipe등 이벤트를 담당합니다.
- Service
    - realm의 CRUD와 관련된 로직을 작성합니다.
- Utils
    - 날짜, Timer, IAP, AppStoreReview, Alert 등 Util과 관련된 파일을 담당합니다.
- I18NStrings, Localizable.strings
    - 한국, 일본, 미국으로 나라별 언어를 관리하는 파일입니다.

---

## **Tech Stack**

- Back-end
- Front-end
    - Swift
    - Realm
    - Firebase/RemoteConfig
    - Google-Mobile-Ads-SDK
    - FSCalendar
    - RandomColorSwift

## **Features & Screens**

### HomeScreen**Page, SearchView**

![Group 4 (1)](https://user-images.githubusercontent.com/45157159/156517275-b2d21022-9f81-478a-8db0-d4c04d5f8812.jpg)

- 할일을 추가하고, 일에 대한 시간을 측정 할 수 있습니다.
- 할일을 미루거나 완료, 제거 할 수 있습니다.
- 설정 뷰, TagView 등 다른 뷰로 이동 할 수 있습니다.

- 전체적인 Todo의 걸린 시간을 확인 할 수 있는 페이지
- Todo 이름으로 검색이 가능하다.

### Todo Add View, TagView

![Group 5 (1)](https://user-images.githubusercontent.com/45157159/156517196-cdd2b2dc-4b04-4948-a11b-5b56723b7510.jpg)

- Todo를 추가하고, Todo에 대한 속성(제목, 태그, 색깔, 반복일자)을 지정 할 수 있습니다.
- Tag를 추가하거나 제거 할 수 있습니다.

### Daily Event Schedule View, Daily Pie View

![Group 3 (1)](https://user-images.githubusercontent.com/45157159/156517219-02f0348f-2fec-48ad-9bb7-436300dab12e.jpg)

- Todo 에 대한 Schedule을 볼 수 있습니다.
- 측정된 Todo의 시간을 수정 할 수 있습니다.
- TableView 위에 Event를 그림.

- 오늘 하루 측정된 Todo의 시간을 Pie Chart로 볼 수 있습니다.
- Bezier 사용, Calendar 라이브러리 사용
- 전체 시간 중 사용한 시간을 볼 수 있습니다.

### SettingView (Premium, iCloud, Notice)

![Group 2 (1)](https://user-images.githubusercontent.com/45157159/156517245-4b7e0223-13fa-4a06-9787-7f75a7a2d264.jpg)

- 결제하기, 백업, 사용한 라이브러리, 공지사항, 문의남기기, 리뷰하기 를 할 수 있습니다.
- 공지 내역에 FireBase RemoteConfigure을 사용함
- iCloud → 백업을 위해 FileSystem 사용함.
- Premium IAP 결제시스템 사용함.

---

# **🛫 Result**

- 앱 개발을 시작하면서 꾸준히 사용 하는 앱을 만들고 싶었는데, 이것저것 따지다 보니 너무 오래걸렸다.
- 디자인을 하는데 공대 감성 디자인이 없어지지 않는다.
- 처음 시작 할 땐, StoryBoard로 시작했는데 동적으로 추가되거나 복잡한 customUI 만들기 위해선programmatically 한 방법이 필요하게 되어 다시 리팩토링을 진행했다.
- 원래는 ScheduleView를 만들 때 Library를 사용했는데 UI를 커스텀하기가 힘들어서 직접 만들었다.
- viewModel 부분을 추가 했는데, react하게 앱을 만들기 위해 리팩토링이 필요해보인다.
