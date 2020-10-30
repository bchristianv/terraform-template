// Jenkinsfile
String credentials_id = 'aws_credentials'

try {
  stage('checkout') {
    node {
      cleanWs()
      checkout scm
    }
  }

  // Run terraform validate
  // stage('validate') {
  //   node {
  //     withCredentials([[
  //       $class: 'AmazonWebServicesCredentialsBinding',
  //       credentialsId: credentials_id,
  //       accessKeyVariable: 'AWS_ACCESS_KEY_ID',
  //       secretKeyVariable: 'AWS_SECRET_ACCESS_KEY'
  //     ]]) {
  //       ansiColor('xterm') {
  //         sh '$HOME/bin/terraform validate'
  //       }
  //     }
  //   }
  // }

  // Run terraform init
  // stage('initialize') {
  //   node {
  //     withCredentials([[
  //       $class: 'AmazonWebServicesCredentialsBinding',
  //       credentialsId: credentials_id,
  //       accessKeyVariable: 'AWS_ACCESS_KEY_ID',
  //       secretKeyVariable: 'AWS_SECRET_ACCESS_KEY'
  //     ]]) {
  //       ansiColor('xterm') {
  //         sh '$HOME/bin/terraform init'
  //       }
  //     }
  //   }
  // }

  // Run terraform plan
  stage('plan') {
    node {
      withCredentials([[
        $class: 'AmazonWebServicesCredentialsBinding',
        credentialsId: credentials_id,
        accessKeyVariable: 'AWS_ACCESS_KEY_ID',
        secretKeyVariable: 'AWS_SECRET_ACCESS_KEY'
      ]]) {
        ansiColor('xterm') {
          sh '$HOME/bin/terraform plan'
        }
      }
    }
  }

  if (env.BRANCH_NAME == 'master') {
    // Run terraform apply
    stage('apply') {
      node {
        withCredentials([[
          $class: 'AmazonWebServicesCredentialsBinding',
          credentialsId: credentials_id,
          accessKeyVariable: 'AWS_ACCESS_KEY_ID',
          secretKeyVariable: 'AWS_SECRET_ACCESS_KEY'
        ]]) {
          ansiColor('xterm') {
            sh '$HOME/bin/terraform apply -auto-approve'
          }
        }
      }
    }

    // Run terraform show
    stage('show') {
      node {
        withCredentials([[
          $class: 'AmazonWebServicesCredentialsBinding',
          credentialsId: credentials_id,
          accessKeyVariable: 'AWS_ACCESS_KEY_ID',
          secretKeyVariable: 'AWS_SECRET_ACCESS_KEY'
        ]]) {
          ansiColor('xterm') {
            sh '$HOME/bin/terraform show'
          }
        }
      }
    }
  }
  currentBuild.result = 'SUCCESS'
}
catch (org.jenkinsci.plugins.workflow.steps.FlowInterruptedException flowError) {
  currentBuild.result = 'ABORTED'
}
catch (err) {
  currentBuild.result = 'FAILURE'
  throw err
}
finally {
  if (currentBuild.result == 'SUCCESS') {
    currentBuild.result = 'SUCCESS'
  }
}
