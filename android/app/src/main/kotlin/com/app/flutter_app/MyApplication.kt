package com.app.flutter_app

import ai.protectt.app.security.common.helper.SDKConstants
import ai.protectt.app.security.common.helper.SDKConstants.ALERT_DIALOG
import ai.protectt.app.security.common.helper.SDKConstants.BOTTOMSHEET_DIALOG
import ai.protectt.app.security.main.AppProtecttInteractor
import ai.protectt.app.security.main.AppProtecttInteractor.Companion.registerCallbackActivities
import ai.protectt.app.security.main.AppProtecttInteractor.Companion.updateCustRefIdAPI
import ai.protectt.app.security.shouldnotobfuscated.dto.ClientInfo
import android.app.Application
import android.provider.Settings.Secure
import android.util.Log
import java.lang.String


class MyApplication : Application() {
    override fun onCreate() {
        super.onCreate()
        System.loadLibrary("ireps")
        //appProtect()
        AppProtecttInteractor.Companion.triggerCheck = true
    }

    private fun appProtect(){
        Log.i("TrustID", "${AppProtecttInteractor.Companion.getTrust(this)}")
        registerCallbackActivities(this)
        val clientInfo = ClientInfo()
        clientInfo.packageName = appPackagename().toString()
        clientInfo.appName = appName().toString() //application name
        clientInfo.channelLicenseKey = channelLicenseKey().toString() //license key
        clientInfo.clientId = clientId().toString().toInt()
        clientInfo.channelId =  channelId().toString().toInt()
        clientInfo.password = password().toString()//password id
        clientInfo.mainAppVersionCode = String.valueOf(BuildConfig.VERSION_CODE)
        clientInfo.appVersionName = BuildConfig.VERSION_NAME
        AppProtecttInteractor.clientInfo = clientInfo

//SDK Initialization
        AppProtecttInteractor(this).initAppProtectt(
            "MainActivity",
            0, R.drawable.launch_background, 0,
            BuildConfig.BUILD_TYPE, BOTTOMSHEET_DIALOG
        )
        val deviceId = Secure.getString(contentResolver, Secure.ANDROID_ID)
        updateCustRefIdAPI(deviceId)

    }

    private external fun password(): String
    private external fun channelId(): String
    private external fun clientId(): String
    private external fun channelLicenseKey(): String
    private external fun appName(): String
    private external fun appPackagename(): String
}