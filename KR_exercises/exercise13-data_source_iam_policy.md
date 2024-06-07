# 데이터 소스를 사용하여 AWS IAM 정책 생성하기

## Introduction

이 연습에서는 AWS IAM 정책을 생성합니다. IAM 정책은 권한을 정의하며 IAM ID 또는 그룹에 연결할 수 있습니다. 우리의 주요 목표는 모든 사용자에게 S3 버킷의 모든 개체에 대한 읽기 액세스 권한을 부여하는 정책을 만드는 것입니다. 이는 정적 웹사이트를 공개적으로 액세스할 수 있도록 만드는 데 필수적입니다. 정책 문서를 만들기 위해 `aws_iam_policy_document` 데이터 소스를 사용하겠습니다. 완성된 정책 문서는 코드의 다른 부분에서 사용할 수 있도록 JSON 형식으로 출력됩니다.

## Desired Outcome

자세한 단계별 내용과 솔루션 동영상을 살펴보기 전에 한 번 사용해 보고 싶은 경우, 생성된 솔루션이 배포해야 하는 내용을 간략하게 살펴보세요:

1. `aws_iam_policy_document` 데이터 소스를 사용하여 IAM 정책 문서를 생성합니다. 이 정책은 모든 사용자에게 적용되어야 하며 S3 버킷의 모든 개체에 대한 읽기 액세스 권한을 부여해야 합니다.
2. 코드의 다른 곳에서 사용할 수 있도록 정책 문서를 JSON 형식으로 출력합니다.

## Step-by-Step Guide

1. `aws_iam_policy_document` 데이터 소스를 활용하여 IAM 정책 문서를 만듭니다. 이 문서에는 부여되는 권한이 명시됩니다. 여기서는 S3 버킷의 모든 개체에 대한 읽기 액세스를 허용하는 정책 문서를 만들고 있습니다.

    ```
    data "aws_iam_policy_document" "static_website" {
      statement {
        sid = "PublicReadGetObject"

        principals {
          type        = "*"
          identifiers = ["*"]
        }

        actions = ["s3:GetObject"]

        resources = ["arn:aws:s3:::*/*"]
      }
    }
    ```

    `principals` 블록에서는 정적 웹사이트를 공개적으로 액세스할 수 있도록 하기 위해 모든 사용자에게 정책이 적용되도록 지정합니다(`type = "*"`).

    `actions` 블록에서 "s3:GetObject" 액션을 지정합니다. 이를 통해 사용자는 S3 버킷에서 개체를 검색할 수 있습니다.

    `resources` 블록은 작업이 적용되는 리소스를 지정합니다. 이 경우 모든 S3 버킷의 모든 개체에 적용됩니다(`"*"` 와일드카드 문자로 표시됨).

2. 정책 문서를 정의한 후 코드의 다른 곳에서 사용할 수 있도록 JSON 형식으로 출력합니다.

    ```
    output "iam_policy" {
      value = data.aws_iam_policy_document.static_website.json
    }
    ```

    `value = data.aws_iam_policy_document.static_website.json` 줄은 정책 문서를 JSON 형식으로 변환합니다.

## Congratulations on Completing the Exercise!

이 연습을 성공적으로 완료하셨습니다! 이제 AWS에서 리소스에 대한 액세스를 관리하는 데 중요한 기술인 AWS IAM 정책을 생성하는 지식을 습득하셨습니다. 계속 연습하여 이해를 더욱 확고히 하세요. 수고하셨습니다!
