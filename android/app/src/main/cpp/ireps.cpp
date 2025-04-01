#include <jni.h>
#include <stdlib.h>
#include <android/log.h>
#include <string>
#include <sys/system_properties.h>
#define  LOG_TAG    "nativelib"
#define  LOGI(...)  __android_log_print(ANDROID_LOG_INFO,LOG_TAG,__VA_ARGS__)

std::string packageName = "in.gov.ireps";
std::string appName = "IREPS";
std::string channelLicenseKey = "00210f7e-ace4-4468-8f41-dd5dc69bae2s";
std::string clientId = "64";
std::string  channelId = "6406";
std::string password = "5ef1d0e97b7c47009d747e88cd2ddc98";


extern "C" JNIEXPORT jstring JNICALL
Java_com_app_flutter_1app_MyApplication_appPackagename(
        JNIEnv* env,
        jobject /* this */) {
    return env->NewStringUTF(packageName.c_str());
}
extern "C" JNIEXPORT jstring JNICALL
Java_com_app_flutter_1app_MyApplication_appName(
        JNIEnv* env,
        jobject /* this */) {
    return env->NewStringUTF(appName.c_str());
}
extern "C" JNIEXPORT jstring JNICALL
Java_com_app_flutter_1app_MyApplication_channelLicenseKey(
        JNIEnv* env,
        jobject /* this */) {
    return env->NewStringUTF(channelLicenseKey.c_str());
}
extern "C" JNIEXPORT jstring JNICALL
Java_com_app_flutter_1app_MyApplication_clientId(
        JNIEnv* env,
        jobject /* this */) {
    return env->NewStringUTF(clientId.c_str());
}
extern "C" JNIEXPORT jstring JNICALL
Java_com_app_flutter_1app_MyApplication_channelId(
        JNIEnv* env,
        jobject /* this */) {
    return env->NewStringUTF(channelId.c_str());
}
extern "C" JNIEXPORT jstring JNICALL
Java_com_app_flutter_1app_MyApplication_password(
        JNIEnv* env,
        jobject /* this */) {
    return env->NewStringUTF(password.c_str());
}

extern "C" void
Java_com_app_flutter_1app_MainActivity_getLoggingStatus(JNIEnv*
env, jobject obj) {
    jclass clazz = env->FindClass("com/app/flutter_app/MainActivity");
    jmethodID status = env->GetMethodID(clazz, "logStatus", "()V");
    env->CallVoidMethod(obj, status);
}
extern "C" JNIEXPORT
jboolean JNICALL
Java_com_app_flutter_1app_MainActivity_checkAnalyticsEnabled(JNIEnv *env, jobject thiz) {
    jclass scanCoreClass = env->FindClass("ai/protectt/app/security/common/helper/NativeInteractor");
    jmethodID initScanCore = env->GetMethodID(scanCoreClass,"<init>", "()V");
    jobject scanCoreObject = env->NewObject(scanCoreClass,initScanCore);
    jmethodID getMethodID = env->GetMethodID(scanCoreClass,"getIslibLoadApp", "()Z");
    jboolean result = env->CallBooleanMethod(scanCoreObject,getMethodID);
    return result;
}
extern "C" JNIEXPORT jstring JNICALL
Java_com_app_flutter_1app_MainActivity_initAnalytics(JNIEnv
                                                                  *env, jobject thiz) {
    abort();
}