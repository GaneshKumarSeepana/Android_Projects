package com.example.healthcareonwheels

import android.os.Bundle
import android.os.Handler
import android.os.Looper
import android.view.View

import android.view.WindowManager
import android.graphics.Color

import android.webkit.WebSettings
import android.webkit.WebView
import android.webkit.WebViewClient
import android.widget.ImageView
import androidx.appcompat.app.AppCompatActivity
import androidx.swiperefreshlayout.widget.SwipeRefreshLayout

class MainActivity : AppCompatActivity() {

    private lateinit var webView: WebView
    private lateinit var swipeRefreshLayout: SwipeRefreshLayout
    private lateinit var splashLogo: ImageView

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)

        // Set status bar color
        window.apply {
            clearFlags(WindowManager.LayoutParams.FLAG_TRANSLUCENT_STATUS)
            addFlags(WindowManager.LayoutParams.FLAG_DRAWS_SYSTEM_BAR_BACKGROUNDS)
            statusBarColor = Color.parseColor("#fa9434") // Custom color (Purple 500 from Material Design)
        }

        splashLogo = findViewById(R.id.splashLogo)
        webView = findViewById(R.id.webview)
        swipeRefreshLayout = findViewById(R.id.swipeRefreshLayout)
        val webSettings: WebSettings = webView.settings

        // WebView settings
        webSettings.javaScriptEnabled = true
        webSettings.domStorageEnabled = true
        webSettings.cacheMode = WebSettings.LOAD_CACHE_ELSE_NETWORK
        webSettings.loadsImagesAutomatically = true
        webView.setLayerType(View.LAYER_TYPE_HARDWARE, null)
        webSettings.setRenderPriority(WebSettings.RenderPriority.HIGH)

        // SwipeRefresh colors
        swipeRefreshLayout.setColorSchemeResources(
            android.R.color.holo_blue_bright,
            android.R.color.holo_green_light,
            android.R.color.holo_orange_light,
            android.R.color.holo_red_light
        )

        webView.webViewClient = object : WebViewClient() {
            override fun onPageStarted(view: WebView?, url: String?, favicon: android.graphics.Bitmap?) {
                swipeRefreshLayout.isRefreshing = true
            }

            override fun onPageFinished(view: WebView?, url: String?) {
                swipeRefreshLayout.isRefreshing = false
            }

            override fun onReceivedError(
                view: WebView?,
                request: android.webkit.WebResourceRequest?,
                error: android.webkit.WebResourceError?
            ) {
                swipeRefreshLayout.isRefreshing = false
            }
        }

        swipeRefreshLayout.setOnRefreshListener {
            webView.reload()
        }

        // Delay for 3 seconds (3000 ms), then show the WebView
        Handler(Looper.getMainLooper()).postDelayed({
            splashLogo.visibility = View.GONE
            swipeRefreshLayout.visibility = View.VISIBLE
            webView.loadUrl("http://healthcare.cutmap.ac.in/")
        }, 2000)
    }

    override fun onBackPressed() {
        if (webView.canGoBack()) {
            webView.goBack()
        } else {
            super.onBackPressed()
        }
    }
}