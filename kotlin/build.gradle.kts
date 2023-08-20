import org.jetbrains.kotlin.gradle.tasks.KotlinCompile

plugins {
    kotlin("jvm") version "1.9.0-RC"
    application
    id("java")
}

group = "app"
version = "1.0"

repositories {
    mavenCentral()
}

dependencies {
}

tasks.withType<KotlinCompile> {
    kotlinOptions.jvmTarget = "19"
}

tasks.withType<JavaCompile> {
    sourceCompatibility = "19"
    targetCompatibility = "19"
}

application {
    mainClass.set("MainKt")
}
