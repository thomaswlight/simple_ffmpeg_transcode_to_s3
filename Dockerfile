FROM jrottenberg/ffmpeg
LABEL maintainer="Tom Light <thomas.w.light@gmail.com>"

USER root

RUN apt-get update && \
    apt-get install python-dev python-pip -y && \
    apt-get clean

RUN pip install awscli

WORKDIR /tmp/workdir

COPY copy_output.sh /tmp/workdir

RUN chmod +x ./copy_output.sh

ENTRYPOINT ffmpeg -i ${INPUT_VIDEO_FILE_URL} -y ${OUTPUT_FILE_NAME} && ./copy_output.sh
