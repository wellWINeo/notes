FROM dart:stable

WORKDIR /app

RUN dart pub global activate conduit
COPY pubspec.* .
RUN dart pub get

COPY . .
RUN chmod +x entrypoint.sh

EXPOSE 80

ENTRYPOINT [ "./entrypoint.sh" ]