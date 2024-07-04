A networking module that should:
1. Create a VPC with a given CIDR block
2. Allow the user to provide the configuration for multiple subnets:
    2.1 The user should be able to provide CIDR blocks
    2.2 The user should be able to provide AWS AZ
    2.3 The user should be able to mark a subnet as public or private
        2.3.1 If at least one subnet is public, we need to deploy an IGW
        2.3.2 We need to associate the public subnets with a public RTB
1. [*] 주어진 CIDR 블록으로 VPC를 생성합니다.
2. 사용자가 여러 서브넷에 대한 구성을 제공하도록 허용합니다:
    2.1 [*] 사용자가 CIDR 블록을 제공할 수 있어야 합니다.
    2.2 [*] 사용자가 AWS AZ를 제공할 수 있어야 합니다.
    2.3 사용자가 서브넷을 공용 또는 사설로 표시할 수 있어야 합니다.
        2.3.1 서브넷이 하나 이상 공용인 경우, IGW를 배포해야 합니다.
        2.3.2 퍼블릭 서브넷을 퍼블릭 RTB와 연결해야 합니다.        