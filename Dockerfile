FROM mcr.microsoft.com/dotnet/runtime:6.0 AS base
WORKDIR /app

FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src
COPY ["ClientTest/ClientTest.csproj", "ClientTest/"]
RUN dotnet restore "ClientTest/ClientTest.csproj"
COPY . .
WORKDIR "/src/ClientTest"
RUN dotnet build "ClientTest.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "ClientTest.csproj" -c Release -o /app/publish /p:UseAppHost=false

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "ClientTest.dll"]