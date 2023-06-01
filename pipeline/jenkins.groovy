pipeline {
    agent any
    parameters {

        choice(name: 'OS', choices: ['linux', 'darwin', 'windows', 'all'], description: 'Pick OS')

    }
    stages {
        stage('Example') {
            steps {
                echo "Build for platform ${params.OS}"
                echo "Build for arch: ${params.ARCH}"

            }
        }

        stage('Test code') {
            steps {
                echo 'Perform testing...'
                sh 'make test'
            }
        }

        stage('Build image') {
            steps {
                echo 'Building docker image...'
                sh 'make image'
            }
        }

        stage('Push image') {
            steps {
                echo 'Pushing docker image...'
                sh 'make push'
            }
        }

    }
}
