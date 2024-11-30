# Etapa 1: Build da aplicação
FROM eclipse-temurin:17-jdk-alpine AS builder

WORKDIR /app

# Copiar apenas os arquivos necessários para o build
COPY build.gradle.kts settings.gradle.kts gradlew ./
COPY gradle ./gradle

# Baixar as dependências do Gradle
RUN ./gradlew dependencies --no-daemon

# Copiar o restante dos arquivos da aplicação
COPY src ./src

# Realizar o build da aplicação
RUN ./gradlew build --no-daemon

# Etapa 2: Executar a aplicação
FROM eclipse-temurin:17-jdk-alpine

WORKDIR /app

# Copiar o JAR gerado na etapa de build
COPY --from=builder /app/build/libs/*.jar backend.jar

EXPOSE 8080

ENTRYPOINT ["java", "-jar", "backend.jar"]
