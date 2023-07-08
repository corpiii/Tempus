# Tempus 

> Tempus, 효율적인 시간관리
> 
> 개발인원: 개인
> 개발기간: 2023.03 ~ 2023.06 (4개월)

## 🍎 프로젝트 소개

[뽀모도로](https://ko.wikipedia.org/wiki/포모도로_기법)를 알고계신가요?

뽀모도로를 기반으로 한 시간관리 앱입니다.

하루를 **블록**으로 나누거나 **집중시간, 휴식시간**을 나누어 관리할 수 있습니다

또한 시간을 정해두고 **계속 반복**할 수도 있어요

## 🛠️ 아키텍쳐

**MVVM-C & Clean Architecture**

![](https://hackmd.io/_uploads/HJzw5iIK3.png)

#### MVVM
- MVVM을 아키텍쳐를 이용해서 ViewController에서 ViewModel로 로직을 분리시켜 주었습니다
- 이를통해 ViewController는 뷰를 그리는데만 집중하고 ViewModel에서 뷰에 들어가는 값을 Unit Test를 할 수 있도록 해주었습니다.

#### Clean Architecture
- 각 객체의 역할과 관심도를 나누어 주기 위해서 Clean Architecture를 도입했습니다.
- 뷰모델의 비즈니스 로직은 UseCase로 나누어 UseCase에 요청하고 값을 받도록 합니다.
- DataManagerRepository protocol을 구현하고 이를 UseCase가 가지도록 해서 구체가 바뀌어도 실행 가능하도록 했습니다.
  - 예를들어 CoreData가 아닌 Realm, SQLite 등의 다른 데이터베이스가 생겨나도 프로토콜만 채택하면 사용 가능하도록 합니다.

#### Coordinator
- ViewModel로 로직을 분리해주었으나 그래도 여전히 ViewController는 조금 무거워서 가독성이 조금 떨어졌습니다.
- Soroush Khanlou의 [coordinator](https://khanlou.com/2015/01/the-coordinator/)와 각종 블로그들을 참고해서 Coordinator 패턴으로 화면전환 로직과 의존성주입 역할을 분리해주었습니다.

## 🌼 기능설명

#### ClockScene

|Clock Start|Clock Empty|
|:---:|:---:|
|![Clock_StartButton](https://github.com/jjpush/Tempus/assets/82566116/c5e91f67-d604-4272-9ba2-4389ab01aba6)|![Clock_Empty](https://github.com/jjpush/Tempus/assets/82566116/ddc80976-4a57-4455-a3f0-066befb86686)|

#### BlockScene

|Block Create|Block Start|Block Edit|Block Delete|
|:---:|:---:|:---:|:---:|
|![Block_Create](https://github.com/jjpush/Tempus/assets/82566116/6c7acea2-a975-4739-860b-dc30f06bafdb)|![Block_Start](https://github.com/jjpush/Tempus/assets/82566116/ba3c0fd9-1976-4069-b035-725c9dca7d9f)|![Block_Edit](https://github.com/jjpush/Tempus/assets/82566116/2d7c3b70-3a9f-46dd-8965-6916c7ee04c5)|![Block_Delete](https://github.com/jjpush/Tempus/assets/82566116/8a23cda7-23d8-47be-ba03-5117940b1056)|

#### DailyScene
|Daily Create|Daily Edit|
|:---:|:---:|
|![Daily_Create](https://github.com/jjpush/Tempus/assets/82566116/53fc3a31-9c9c-41a1-a960-47e9518d70f7)|![Daily_Edit](https://github.com/jjpush/Tempus/assets/82566116/1cb98108-1215-451f-81e9-f4054ca11828)|

#### TimerScene
|Timer Start|
|:---:|
|![Timer_Start](https://github.com/jjpush/Tempus/assets/82566116/292a0f37-1ac1-4b45-a5ab-f9a26add29da)|

## 🔥 기술적 도전
- RxSwift
- SnapKit
- Custom View
- UseCase내 Input, Output
