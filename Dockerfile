FROM sammax23/rcmltb

#RUN mv /usr/bin/rclone /usr/bin/test

#RUN echo -e '#!/bin/bash\ntest $@' > /usr/bin/rclone && \
#    chmod +x /usr/bin/rclone

WORKDIR /usr/src/app
RUN chmod 777 /usr/src/app

COPY . .
RUN pip3 install --no-cache-dir -r requirements.txt

CMD ["bash", "start.sh"]
