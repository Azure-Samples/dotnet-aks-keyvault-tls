FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
WORKDIR /src
EXPOSE 80
EXPOSE 443

ENV ASPNETCORE_URLS=https://+:443;http://+:80

FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src
COPY "dotnet-aks-keyvault-tls.csproj" .
RUN dotnet restore "dotnet-aks-keyvault-tls.csproj"

COPY . .
RUN dotnet build "dotnet-aks-keyvault-tls.csproj" -c Release -o /app

FROM build AS publish
RUN dotnet publish "dotnet-aks-keyvault-tls.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
CMD ["dotnet", "dotnet-aks-keyvault-tls.dll"]