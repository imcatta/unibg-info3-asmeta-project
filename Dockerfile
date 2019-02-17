FROM openjdk:8-jre-alpine
RUN apk update && apk add curl
RUN curl http://svn.code.sf.net/p/asmeta/code/code/stable/simulator/asmeta.simulator.cli/AsmetaS.jar -o /bin/AsmetaS.jar
RUN apk del curl && rm -rf /var/cache/apk/*
COPY . /app
CMD ["java", "-jar", "/bin/AsmetaS.jar", "/app/GameOfLife.asm"]