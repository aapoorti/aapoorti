## Flutter wrapper
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-keep class io.flutter.**  { *; }
-keep class io.flutter.plugins.**  { *; }
-keepattributes *Annotation*

-keepclassmembers class ai.protectt.app.security.shouldnotobfuscated** {*;}

-keepclassmembers class com.android.volley** {*;}

-keepclassmembers class com.scottyab** {*;}

-keep class com.google.gson.Gson** {*;}

-keepattributes Exceptions,InnerClasses,Signature,Deprecated,SourceFile,LineNumberTable,*Annotation*,EnclosingMethod

-keepattributes Signature

-keep class ai.protectt.app.security.common.helper.NDKTrustInteractor {

      encryptedAESKey(**);

}

# Please add these rules to your existing keep rules in order to suppress warnings.
# This is generated automatically by the Android Gradle plugin.
-dontwarn com.google.android.play.core.integrity.IntegrityManager
-dontwarn com.google.android.play.core.integrity.IntegrityManagerFactory
-dontwarn com.google.android.play.core.integrity.IntegrityTokenRequest$Builder
-dontwarn com.google.android.play.core.integrity.IntegrityTokenRequest
-dontwarn com.google.android.play.core.integrity.IntegrityTokenResponse
-dontwarn com.google.android.play.core.splitcompat.SplitCompatApplication
-dontwarn com.google.android.play.core.splitinstall.SplitInstallException
-dontwarn com.google.android.play.core.splitinstall.SplitInstallManager
-dontwarn com.google.android.play.core.splitinstall.SplitInstallManagerFactory
-dontwarn com.google.android.play.core.splitinstall.SplitInstallRequest$Builder
-dontwarn com.google.android.play.core.splitinstall.SplitInstallRequest
-dontwarn com.google.android.play.core.splitinstall.SplitInstallSessionState
-dontwarn com.google.android.play.core.splitinstall.SplitInstallStateUpdatedListener
-dontwarn com.google.android.play.core.tasks.OnFailureListener
-dontwarn com.google.android.play.core.tasks.OnSuccessListener
-dontwarn com.google.android.play.core.tasks.Task

-dontoptimize
-keep class com.app.flutter_app.MainActivity {logStatus();}
