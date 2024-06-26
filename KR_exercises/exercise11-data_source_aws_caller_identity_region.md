# 데이터 소스를 사용하여 AWS 호출자 신원 및 지역 가져오기

## Introduction

이 연습에서는 AWS 발신자 신원 및 AWS 리전 데이터 소스의 이해와 활용에 중점을 두겠습니다. 목표는 AWS 발신자 신원 및 AWS 리전 모두에 대한 데이터 소스를 정의하는 것입니다. 그런 다음 호출자의 반환된 ID와 현재 AWS 리전을 출력할 것입니다. 테라폼 기술을 향상시키고 이러한 특정 측면에 대한 친숙도를 높이는 데 유용한 연습입니다.

## Desired Outcome

자세한 단계별 내용과 솔루션 동영상을 살펴보기 전에 한 번 사용해 보고 싶은 경우, 생성된 솔루션이 배포해야 하는 내용을 간략하게 살펴보세요:

1. AWS 발신자 신원 데이터 소스: 이 데이터 소스는 호출자의 신원을 반환하도록 정의해야 합니다.
2. AWS 리전 데이터 소스: 이 데이터 소스는 현재 AWS 리전을 가져오도록 정의해야 합니다.
3. AWS 호출자 신원 출력: 이 출력은 호출자의 신원을 반환해야 합니다.
4. AWS 리전 출력: 이 출력은 현재 AWS 리전을 반환해야 합니다.

## Step-by-Step Guide

1.  먼저 AWS 호출자 신원에 대한 데이터 소스를 정의합니다. 이 데이터 소스는 호출자의 ID를 반환하는 데 사용됩니다. 이는 다음 코드를 사용하여 수행됩니다:

    ```
    data "aws_caller_identity" "current" {}
    ```

2.  다음으로 AWS 리전에 대한 데이터 소스를 정의합니다. 이 데이터 소스는 현재 지역을 가져오는 데 사용됩니다. 이 작업은 다음 코드를 사용하여 수행합니다:

    ```
    data "aws_region" "current" {}
    ```

3.  그런 다음 AWS 호출자 ID를 출력합니다. 그러면 호출자의 ID가 반환됩니다. 이 작업은 다음 코드를 사용하여 수행합니다:

    ```
    output "aws_caller_identity" {
      value = data.aws_caller_identity.current
    }
    ```

    이 데이터 소스를 통해 검색되는 정보의 종류는 무엇인가요?

4.  마지막으로 AWS 리전을 출력합니다. 그러면 현재 지역이 반환됩니다. 이 작업은 다음 코드를 사용하여 수행합니다:

    ```
    output "aws_region" {
      value = data.aws_region.current
    }
    ```

    이 데이터 소스를 통해 검색되는 정보의 종류는 무엇인가요?

## Congratulations on Completing the Exercise!

AWS Caller 신원 및 리전에 대한 연습을 성공적으로 완료하셨습니다! 테라폼 기술을 향상시키는 데 있어 또 하나의 중요한 단계를 밟으셨습니다. 계속 열심히 하세요!
