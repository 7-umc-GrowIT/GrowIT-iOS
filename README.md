# GrowIT-iOS
> (프로젝트 설명)
## 🍎 Developers

| [@강희정](https://github.com/tansxx) | [@오현민](https://github.com/hyunm1n-o) | [@이수현](https://github.com/JustinLee02) | [@허준호](https://github.com/helljh) |
|:---:|:---:|:---:|:---:|
| image | image | image | image |
| `stack` | `stack` | `stack` | `stack` |

## 🛠 Development Environment

## ✏️ Project Design

## 💻 Code Convention
[🔗 Code Convention](https://udacity.github.io/git-styleguide/)
> **1. Commit 메시지 구조**
> 

기본 적인 커밋 메시지 구조는 **`제목`,`본문`,`꼬리말`** 세가지 파트로 나누고, 각 파트는 빈줄을 두어 구분한다.

```jsx
[타입] 제목

본문

꼬리말
```

> **2. Commit Type (타입)**
> 
> 
> 타입은 태그와 제목으로 구성되고, 태그는 영어로 쓰되 첫 문자는 대문자로 한다.
> 

 **`[태그] 제목`의 형태**

- `feat` : 새로운 기능 추가
- `fix` : 버그 수정
- `docs` : 문서 수정
- `style` : 코드 포맷팅, 세미콜론 누락, 코드 변경이 없는 경우
- `refactor` : 코드 리펙토링
- `test` : 테스트 코드, 리펙토링 테스트 코드 추가
- `chore` : 빌드 업무 수정, 패키지 매니저 수정

> **3. Subject (제목)**
> 
> - 제목은 최대 50글자가 넘지 않도록 하고 마침표 및 특수기호는 사용하지 않는다.
> - 제목은 완전한 서술형 문장이 아니라, 간결하고 요점적인 문장으로 적는다.

> 4. **Body (본문)**
> 

본문은 다음의 규칙을 지킨다.

- 본문은 한 줄 당 72자 내로 작성한다.
- 본문 내용은 양에 구애받지 않고 최대한 상세히 작성한다.
- 본문 내용은 어떻게 변경했는지 보다 무엇을 변경했는지 또는 왜 변경했는지를 설명한다.

> **5. footer (꼬릿말, 선택사항)**
> 

꼬릿말은 다음의 규칙을 지킨다.

- 꼬리말은 `"유형: #이슈 번호"` 형식으로 사용한다.
- 여러 개의 이슈 번호를 적을 때는 `쉼표(,)`로 구분한다.
- 이슈 트래커 유형은 다음 중 하나를 사용한다.
    - `Fixes`: 이슈 수정중 (아직 해결되지 않은 경우)
    - `Resolves`: 이슈를 해결했을 때 사용
    - `Ref`: 참고할 이슈가 있을 때 사용
    - `Related to`: 해당 커밋에 관련된 이슈번호 (아직 해결되지 않은 경우)
    **`ex) Fixes: #45 Related to: #34, #23`**

> **6. Commit 예시**
> 

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

## 🎁 Library
| Name         | Version  |
| ------------ |  :-----: | 
| [Then](https://github.com/devxoul/Then) | `3.0.0` |
| [SnapKit](https://github.com/SnapKit/SnapKit) | `5.7.1` |
| [Moya](https://github.com/Moya/Moya) |  `15.0.3`  |

## 🔥 Trouble Shooting
