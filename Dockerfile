FROM mcr.microsoft.com/mssql/server:2022-latest
LABEL maintainer="maxim5858mru@live.ru"

ENV ACCEPT_EULA=Y
ENV MSSQL_SA_PASSWORD=KqGN?a9Yvi
ENV MSSQL_PID=Developer
ENV LANG=ru_RU.UTF-8

EXPOSE 1433
EXPOSE 135

USER 0
RUN apt-get update && apt-get upgrade -y && apt-get install -y locales && locale-gen ru_RU.UTF-8 && update-locale LANG=ru_RU.UTF-8
RUN apt-get install -y mssql-tools unixodbc-dev nmap
RUN echo "/opt/mssql-tools/bin/sqlcmd -S 127.0.0.1,1433 -U sa -P '${MSSQL_SA_PASSWORD}'" > sqlcmd.sh && chmod +x sqlcmd.sh
CMD /opt/mssql/bin/sqlservr

# docker run -it --expose 1-65535 -p 1433:1433 -p 13500:135 --hostname Microsoft-SQL-Server --name microsoft-sql-server-developer maxim5858mru/lessons-database