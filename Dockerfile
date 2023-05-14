FROM ubuntu:18.04
RUN  apt-get update 
RUN apt-get install tcl -y 
RUN apt-get install -y  \
           postgresql-client \
           tesseract-ocr \
           
RUN  wget https://discusbackup.s3.ap-south-1.amazonaws.com/All-repo/ImageMagick-6.9.10-97.tar.gz && \
tar xvzf ImageMagick-6.9.10-97.tar.gz && \
rm -r ImageMagick-6.9.10-97.tar.gz && \

expose 8080
expose 8443
expose 80
   
volumes:
   application:
   frontend:
   sites-enabled:
CMD /etc/init.d/nginx start ; sh /application/wildfly-13.0.0.Final/bin/standalone.sh

volumes:
       - application:/application
       - frontend:/usr/share/nginx/html
       - sites-enabled:/etc/nginx/sites-enabled
