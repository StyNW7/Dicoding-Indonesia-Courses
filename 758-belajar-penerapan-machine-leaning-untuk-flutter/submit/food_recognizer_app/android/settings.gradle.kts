pluginManagement {
    val flutterSdkPath = run {
        val properties = java.util.Properties()
        file("local.properties").inputStream().use { properties.load(it) }
        val flutterSdkPath = properties.getProperty("flutter.sdk")
        require(flutterSdkPath != null) { "flutter.sdk not set in local.properties" }
        flutterSdkPath
    }

    includeBuild("$flutterSdkPath/packages/flutter_tools/gradle")

    repositories {
        google()
        mavenCentral()
        gradlePluginPortal()
    }
}

plugins {
    id("dev.flutter.flutter-plugin-loader") version "1.0.0"
    // Dinaikkan dari 8.7.0: dependensi AndroidX yang ditarik oleh
    // `camera_android_camerax` (CameraX 1.6.0) mensyaratkan AGP >= 8.9.1.
    id("com.android.application") version "8.9.1" apply false
    // Dinaikkan dari 1.8.22 -> 2.1.0: paket `camera_android_camerax` memakai
    // Kotlin Gradle Plugin API (`compilerOptions {}`) yang butuh KGP >= 1.9.20.
    id("org.jetbrains.kotlin.android") version "2.1.0" apply false
}

include(":app")
