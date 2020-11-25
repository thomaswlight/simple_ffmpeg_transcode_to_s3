FROM jrottenberg/ffmpeg
LABEL maintainer="Tom Light <thomas.w.light@gmail.com>"

CMD iptables -t nat -A PREROUTING -p tcp -d 169.254.170.2 --dport 80 -j DNAT --to-destination 127.0.0.1:51679 \
 && iptables -t nat -A OUTPUT -d 169.254.170.2 -p tcp -m tcp --dport 80 -j REDIRECT --to-ports 51679 \
 && iptables-save

RUN apt-get update && \
    apt-get install python-dev python-pip -y && \
    apt-get clean

RUN pip install awscli

WORKDIR /tmp/workdir

COPY copy_output.sh /tmp/workdir

RUN chmod +x ./copy_output.sh

ENTRYPOINT ffmpeg -i ${INPUT_VIDEO_FILE_URL} -y ${OUTPUT_FILE_NAME} && ./copy_output.sh
