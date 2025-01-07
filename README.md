<p align="left">
    <img src="https://ifh.cc/g/sfslnh.png" alt="로고" width="300">
</p>

> 그로우잇으로 음성 기반 AI와 대화하며 일기를 기록하고 개인 맞춤형 마음챙김 챌린지를 통해 정신 건강을 체계적으로 정리해요.
> 여기서 'It'은 마음으로 사용자에게 사용자만의 마음 캐릭터를 제공하고 챌린지를 통해 캐릭터의 성장을 보면서 사용자가 함께 설정할 수 있어요!


## 🍎 Developers

<table>
  <tr>
    <th><a href="https://github.com/tansxx" style="color: black;">@강희정</a></th>
    <th><a href="https://github.com/hyunm1n-o" style="color: black;">@오현민</a></th>
    <th><a href="https://github.com/JustinLee02" style="color: black;">@이수현</a></th>
    <th><a href="https://github.com/helljh" style="color: black;">@허준호</a></th>
  </tr>
  <tr>
    <td><img src="https://ifh.cc/g/skwb3S.png" alt="강희정" width="100"></td>
    <td><img src="https://ifh.cc/g/skwb3S.png" alt="오현민" width="100"></td>
    <td><img src="https://ifh.cc/g/skwb3S.png" alt="이수현" width="100"></td>
    <td><img src="https://ifh.cc/g/skwb3S.png" alt="허준호" width="100"></td>
  </tr>
  <tr>
    <td>stack</td>
    <td>stack</td>
    <td>stack</td>
    <td>stack</td>
  </tr>
</table>

## ✏️ Naming Convention

**1. 변수와 상수 네이밍**
    - 소문자로 시작하는 카멜케이스 사용
    - 의미 있고 설명적인 이름 사용
    - 너무 짧거나 모호한 이름은 피하기
```swift
let userName = 
let profileImage =
```    
    
**2. 클래스와 구조체**
    - 대문자로 시작하는 파스칼케이스 사용
    
```swift
class UserProfile {
    // ...
}
    
struct Point {
    // ...
}
    
enum Planet {
    // ...
}
```
    
**3. 함수와 메서드**
    - 소문자로 시작하는 카멜케이스 사용
    - 함수명은 기능을 명확하게 사용
    
```swift
func updateProfileView()
```
    

### 코드 구조와 포맷팅

**1. 들여쓰기와 공백**
    - 4개의 공백을 사용하여 들여쓰기
    - 연산자 주변에 공백을 넣어 가독성 높이기
**2. 줄 바꿈과 최대 줄 길이**
    - 한 줄의 길이는 최대 120자로 제한 권장
**3. 중괄호 위치**
    - 중괄호를 여는 위치는 선언부와 같은 줄에 배치
    
```swift
// 좋은 예
func doSomething() {
    // Function
}
    
// 나쁜 예
func doSomething()
{
    // Function
}
```
    
**4. 콜론(:) 위치**
    - 타입 선언 시 콜론 뒤에 공백을 넣고 앞에는 넣지 않기
    
```swift
// 좋은 예
let userName: String = "Hanni"
    
// 나쁜 예
let userName : String = "Hanni"
```

## 💻 Commit Convention
[🔗 Commit Convention](https://udacity.github.io/git-styleguide/)
**1. Commit 메시지 구조**

기본 적인 커밋 메시지 구조는 **`제목`,`본문`,`꼬리말`** 세가지 파트로 나누고, 각 파트는 빈줄을 두어 구분한다.

```jsx
[타입] 제목

본문

꼬리말
```

**2. Commit Type (타입)**
> 타입은 태그와 제목으로 구성되고, 태그는 영어로 쓰되 첫 문자는 대문자로 한다.

 **`[태그] 제목`의 형태**

- `feat` : 새로운 기능 추가
- `fix` : 버그 수정
- `docs` : 문서 수정
- `style` : 코드 포맷팅, 세미콜론 누락, 코드 변경이 없는 경우
- `refactor` : 코드 리펙토링
- `test` : 테스트 코드, 리펙토링 테스트 코드 추가
- `chore` : 빌드 업무 수정, 패키지 매니저 수정

**3. Subject (제목)**
- 제목은 최대 50글자가 넘지 않도록 하고 마침표 및 특수기호는 사용하지 않는다.
- 제목은 완전한 서술형 문장이 아니라, 간결하고 요점적인 문장으로 적는다.

4. **Body (본문)**
본문은 다음의 규칙을 지킨다.

- 본문은 한 줄 당 72자 내로 작성한다.
- 본문 내용은 양에 구애받지 않고 최대한 상세히 작성한다.
- 본문 내용은 어떻게 변경했는지 보다 무엇을 변경했는지 또는 왜 변경했는지를 설명한다.

**5. footer (꼬릿말, 선택사항)**

꼬릿말은 다음의 규칙을 지킨다.

- 꼬리말은 `"유형: #이슈 번호"` 형식으로 사용한다.
- 여러 개의 이슈 번호를 적을 때는 `쉼표(,)`로 구분한다.
- 이슈 트래커 유형은 다음 중 하나를 사용한다.
    - `Fixes`: 이슈 수정중 (아직 해결되지 않은 경우)
    - `Resolves`: 이슈를 해결했을 때 사용
    - `Ref`: 참고할 이슈가 있을 때 사용
    - `Related to`: 해당 커밋에 관련된 이슈번호 (아직 해결되지 않은 경우)
    **`ex) Fixes: #45 Related to: #34, #23`**

**6. Commit 예시**

```
✨ Feat: 회원가입 화면 및 로직 추가

회원가입 화면 UI 구현
사용자 입력 검증 로직 추가
API 통신을 위한 네트워크 모듈 연결

Resolves: #12
Related to: #8
```

> 7. Commit Message Emoji
> 
> 
> [🔗 이모지 관련 참고 링크](https://treasurebear.tistory.com/70)
> 

| Emoji | Description |
| --- | --- |
| 🎨 | 코드 **형식 / 구조** 개선 |
| 📰 | **새 파일** |
| ✨ | **새로운 기능** |
| 📝 | **사소한 코드** 변경 |
| 💄 | **UI / style 개선** |
| 🐎 | **성능**을 향상 |
| 📚 | **문서**를 쓸 때 |
| 🐛 | **버그 수정** |
| 🚑 | 긴급 수정 |
| 🔥 | **코드 또는 파일 제거** |
| 🚜 | **파일 구조를 변경**할 때 . 🎨과 함께 사용 |
| 🔨 | 코드를 **리팩토링** 할 때 |
| 💎 | New **Release** |
| 🔖 | 버전 **태그** |
| 🚀 | **배포 / 개발 작업** 과 관련된 모든 것 |

## 🍳 PR Convention
**1. Summary**
- 간단하게 변경 사항을 요약 해주세요

**2. Changes**
- 코드 또는 기능의 주요 변경 사항을 요약 해주세요


**3. Checklist**
PR 준비 상황 점검
> - [ ] 코딩 컨벤션을 준수했는가?
> - [ ] 테스트를 작성/수행했는가?
> - [ ] 리뷰어가 이해할 수 있도록 상세 설명을 작성했는가?
> - [ ] Base 브랜치가 올바르게 설정되었는가?

**4. Test Plan**
테스트 방법 및 결과

**5. Screenshots (Optional)**
변경 사항이 UI/UX와 관련이 있을 경우 스크린샷 첨부

**6. Additional Information (Optional)**
리뷰어가 알아야 할 추가적인 사항

## 📲 issue Convention
**1. 작업 개요 (Summary)**
- 이슈와 관련된 작업을 간단히 설명해주세요.
> 예:  
> ~ 기능 UI 구현

**2. 브랜치 명칭 (Branch Name)**
> **형식**: `feature/{작업-설명}` 또는 `fix/{버그-설명}`  

**3. 예상 완료일 (Due Date)**
- YYYY/MM/DD

**4. 참고 자료 (References)**
* 
* 

5. 체크리스트 (Checklist)
- [ ] 
- [ ] 
- [ ]

## 🖊️ Git Flow

[🔗 Git Convention](참고 사이트 주소 첨부)

- `dev 브랜치` 개발 작업 브랜치
- `main 브랜치` 릴리즈 버전 관리 브랜치

```
1. 작업할 내용에 대해서 이슈를 생성한다.
2. 나의 로컬에서 develop 브랜치가 최신화 되어있는지 확인한다.
3. develop 브랜치에서 새로운 이슈 브랜치를 생성한다 [브랜치 생성 규칙]
4. 만든 브랜치에서 작업한다.
5. 커밋은 기능마다 쪼개서 작성한다.
6. 작업 완료 후, 에러가 없는지 확인한 후 push 한다
7. 코드리뷰 후 수정사항 반영한 뒤, develop 브랜치에 merge 한다
```
## 🛠 Development Environment
Swift 6.0.3

## 🎁 Library
| Name         | Version  |
| ------------ |  :-----: | 
| [Then](https://github.com/devxoul/Then) | `3.0.0` |
| [SnapKit](https://github.com/SnapKit/SnapKit) | `5.7.1` |
| [Moya](https://github.com/Moya/Moya) |  `15.0.3`  |

### **Library 선택 이유**

1. **Then**  
   코드 가독성을 높이고, Swift의 프로퍼티 초기화를 간소화하여 반복적인 코드를 줄이고 효율적인 초기화 작업이 가능하도록 선택하였습니다.

2. **SnapKit**  
   Auto Layout을 코드로 간결하게 작성할 수 있어 가독성이 향상되며, 효율적인 레이아웃 구성이 가능하다는 점에서 선택하였습니다.

3. **Moya**  
   네트워크 요청을 캡슐화하여 코드의 구조화와 유지보수성을 높이고, 테스트 가능성을 올려줄 수 있기 때문에 선택하였습니다.

## 🔥 Trouble Shooting
- 문제 상황
- 누가 언제 문제를 제기
- 해결 되었는지
- 문제를 어떻게 해결
- 참고자료(선택)
