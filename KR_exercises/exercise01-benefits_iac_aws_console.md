# AWS에서 수동으로 VPC와 서브넷 생성하기

## Introduction

이 연습에서는 AWS 콘솔에서 간단한 VPC-서브넷 인프라를 수동으로 구축하는 데 중점을 두겠습니다. 여기에는 VPC, 2개의 서브넷(공용 및 사설), 인터넷 게이트웨이 및 공용 라우트 테이블을 만드는 것이 포함됩니다. 이러한 요소를 수동으로 생성함으로써 인프라를 생성하고 관리하는 프로세스가 얼마나 복잡하고 어려운지 더 깊이 이해할 수 있습니다. 이를 통해 이러한 작업을 자동화하고 환경 전반에서 일관성을 유지하는 데 있어 코드형 인프라(IaC)의 이점을 이해할 수 있는 토대를 마련할 수 있습니다.
## Desired Outcome

생성된 솔루션이 배포하는 내용은 아래와 같습니다.:

1. CIDR 블록이 `10.0.0.0/16`인 VPC.
2. CIDR 블록이 `10.0.0.0/24`인 Public Subnet 하나.
3. CIDR 블록이 `10.0.1.0/24`인 Private Subnet 하나.
4. 인터넷 게이트웨이 하나.
5. 인터넷 게이트웨이에 대한 Route설정이 있는 Pblic Route Table 하나, Public Subnet과 Public Route Table 간의 올바른 연결.

## Step-by-Step Guide

1. AWS 콘솔에 로그인합니다.
2. VPC 대시보드로 이동합니다.
3. "내 VPC"를 클릭한 다음 "VPC 생성"을 클릭합니다.
4. 이름 태그와 CIDR 블록 `10.0.0.0/16`을 입력한 후 "생성"을 클릭합니다.
5. VPC 대시보드로 돌아가서 "서브넷"을 클릭합니다.
6. "서브넷 생성"을 클릭합니다.
7. 이름 태그를 입력하고 방금 생성한 VPC를 선택한 후 CIDR 블록 `10.0.0.0/24`를 입력해 Public Subnet을 생성합니다.
8. CIDR 블록 `10.0.1.0/24`로 이 과정을 반복하여 Private Subnet을 생성합니다.
9. 9. VPC 대시보드로 돌아가서 "인터넷 게이트웨이"를 클릭합니다.
10. "인터넷 게이트웨이 생성"을 클릭하고 이름 태그를 지정한 다음 "생성"을 클릭합니다.
11. 방금 생성한 인터넷 게이트웨이를 선택하고 "작업"을 클릭한 다음 "VPC에 연결"을 클릭하고 VPC를 선택합니다.
12. VPC 대시보드로 돌아가서 "라우팅 테이블"을 클릭합니다.
13. "라우팅 테이블 만들기"를 클릭하고 이름 태그를 입력한 후 VPC를 선택한 다음 "만들기"를 클릭합니다.
14. 방금 생성한 라우팅 테이블을 선택하고 "라우팅" 탭을 클릭한 다음 "라우팅 편집"을 클릭합니다.
15. "라우팅 추가"를 클릭하고 목적지에 `0.0.0.0/0`을 입력하고 대상에 생성한 인터넷 게이트웨이를 선택한 다음 "라우팅 저장"을 클릭합니다.
16. "서브넷 연결" 탭을 클릭한 다음 "서브넷 연결 편집"을 클릭합니다.
17. Public Subnet을 선택한 다음 "저장"을 클릭합니다.


## 연습 종료!

이 어려운 연습을 성공적으로 완료하신 것을 축하드립니다! AWS 콘솔에서 VPC 서브넷 인프라를 수동으로 구축했으며, 이 실습 경험을 통해 인프라 생성 및 관리의 프로세스와 복잡성에 대한 귀중한 인사이트를 얻으셨습니다. 이 실습을 통해 이러한 작업을 자동화하고 환경 전반에서 일관성을 유지하는 데 있어 코드형 인프라(IaC)의 이점을 이해하는 데 도움이 되셨기를 바랍니다.