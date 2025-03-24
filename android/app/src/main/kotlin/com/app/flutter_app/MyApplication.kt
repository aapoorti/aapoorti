package com.app.flutter_app

import ai.protectt.app.security.common.helper.SDKConstants.ALERT_DIALOG
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
        appProtect()
    }

    private fun appProtect(){
        Log.i("TrustID", "${AppProtecttInteractor.Companion.getTrust(this)}")
        registerCallbackActivities(this)
        val clientInfo = ClientInfo()
        clientInfo.packageName = "in.gov.ireps" //package name
        clientInfo.appName = "IREPS" //application name
        clientInfo.channelLicenseKey = "00210f7e-ace4-4468-8f41-dd5dc69bae2s" //license key
        clientInfo.clientId = 64
        clientInfo.channelId =  6406
        clientInfo.password = "5ef1d0e97b7c47009d747e88cd2ddc98" //password id
        clientInfo.mainAppVersionCode = String.valueOf(BuildConfig.VERSION_CODE)
        clientInfo.appVersionName = BuildConfig.VERSION_NAME
        AppProtecttInteractor.clientInfo = clientInfo

//SDK Initialization
        AppProtecttInteractor(this).initAppProtectt(
            "SplashScreen",
            R.layout.alert_layout_logo, R.drawable.launch_background, R.style.AlertDialogCustom,
            BuildConfig.BUILD_TYPE, ALERT_DIALOG
        )
        val deviceId = Secure.getString(contentResolver, Secure.ANDROID_ID)
        updateCustRefIdAPI(deviceId)

    }
}