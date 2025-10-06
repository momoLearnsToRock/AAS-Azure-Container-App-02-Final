FROM mcr.microsoft.com/dotnet/aspnet:9.0 AS base
WORKDIR /app
EXPOSE 5000

ENV ASPNETCORE_URLS=http://+:5000

USER app
FROM --platform=$BUILDPLATFORM mcr.microsoft.com/dotnet/sdk:9.0 AS build
ARG configuration=Release
WORKDIR /src
COPY ["AAS-Azure-Container-App-02-Final.csproj", "./"]
RUN dotnet restore "AAS-Azure-Container-App-02-Final.csproj"
COPY . .
WORKDIR "/src/."
RUN dotnet build "AAS-Azure-Container-App-02-Final.csproj" -c $configuration -o /app/build

FROM build AS publish
ARG configuration=Release
RUN dotnet publish "AAS-Azure-Container-App-02-Final.csproj" -c $configuration -o /app/publish /p:UseAppHost=false

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "AAS-Azure-Container-App-02-Final.dll"]
