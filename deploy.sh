#!/bin/bash
SERVICE_NAME=$SERVICE_NAME
CLUSTER_NAME=$CLUSTER_NAME
BUILD_NUMBER=${CIRCLE_BUILD_NUM}
IMAGE_TAG=${CIRCLE_SHA1}
TASK_FAMILY=$TASK_FAMILY

# Create a new task definition for this build
sed -e "s/%IMAGE_TAG%/${IMAGE_TAG}/g; s/%AWS_ACCOUNT%/$AWS_ACCOUNT/g; s/%AWS_REGION%/$AWS_REGION/g; s/%AWS_REPO%/$AWS_REPO/g; s/%BRANCH%/$CIRCLE_BRANCH/g" fargate-template-task.json > task-${BUILD_NUMBER}.json
aws ecs register-task-definition --family ${TASK_FAMILY} --cli-input-json file://task-${BUILD_NUMBER}.json

# Update the service with the new task definition and desired count
TASK_REVISION=`aws ecs describe-task-definition --task-definition ${TASK_FAMILY} | egrep "revision" | tr "/" " " | awk '{print $2}' | sed 's/"$//'`
DESIRED_COUNT=`aws ecs describe-services --cluster ${CLUSTER_NAME} --services ${SERVICE_NAME} | egrep "desiredCount" | head -1 | tr "/" " " | awk '{print $2}' | sed 's/,$//'`
if [ ${DESIRED_COUNT} = "0" ]; then
    DESIRED_COUNT="1"
fi

aws ecs update-service --cluster ${CLUSTER_NAME} --service ${SERVICE_NAME} --task-definition ${TASK_FAMILY}:${TASK_REVISION} --desired-count ${DESIRED_COUNT}
