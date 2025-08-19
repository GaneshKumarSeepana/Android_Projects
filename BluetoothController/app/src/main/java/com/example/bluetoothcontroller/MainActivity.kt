package com.example.bluetoothcontroller

import android.Manifest
import android.bluetooth.BluetoothAdapter
import android.bluetooth.BluetoothDevice
import android.bluetooth.BluetoothSocket
import android.content.Intent
import android.content.pm.PackageManager
import android.os.Bundle
import android.speech.RecognizerIntent
import android.view.View
import android.widget.Toast
import androidx.activity.result.contract.ActivityResultContracts
import androidx.appcompat.app.AppCompatActivity
import androidx.core.content.ContextCompat
import com.example.bluetoothcontroller.databinding.ActivityMainBinding
import java.io.IOException
import java.util.UUID

class MainActivity : AppCompatActivity() {

    private lateinit var binding: ActivityMainBinding
    private val bluetoothAdapter: BluetoothAdapter? = BluetoothAdapter.getDefaultAdapter()
    private var bluetoothSocket: BluetoothSocket? = null
    private var device: BluetoothDevice? = null
    private val uuid = UUID.fromString("00001101-0000-1000-8000-00805F9B34FB") // SPP UUID for HC-05/HC-06

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binding = ActivityMainBinding.inflate(layoutInflater)
        setContentView(binding.root)

        checkPermissions()
        setupButtonListeners()
    }

    private fun checkPermissions() {
        val permissions = arrayOf(
            Manifest.permission.BLUETOOTH,
            Manifest.permission.BLUETOOTH_ADMIN,
            Manifest.permission.BLUETOOTH_CONNECT,
            Manifest.permission.RECORD_AUDIO
        )
        if (permissions.any { ContextCompat.checkSelfPermission(this, it) != PackageManager.PERMISSION_GRANTED }) {
            requestPermissionsLauncher.launch(permissions)
        } else {
            setupBluetooth()
        }
    }

    private val requestPermissionsLauncher = registerForActivityResult(ActivityResultContracts.RequestMultiplePermissions()) { permissions ->
        if (permissions.all { it.value }) {
            setupBluetooth()
        } else {
            Toast.makeText(this, "Permissions denied. App functionality limited.", Toast.LENGTH_LONG).show()
        }
    }

    private fun setupBluetooth() {
        if (bluetoothAdapter == null) {
            Toast.makeText(this, "Bluetooth not supported on this device", Toast.LENGTH_LONG).show()
            return
        }
        if (!bluetoothAdapter!!.isEnabled) {
            startActivity(Intent(BluetoothAdapter.ACTION_REQUEST_ENABLE))
        }

        binding.connectButton.setOnClickListener { connectToBluetooth() }
        binding.disconnectButton.setOnClickListener { disconnectBluetooth() }
        updateButtonStates(isConnected = false)
    }

    private fun connectToBluetooth() {
        val pairedDevices: Set<BluetoothDevice>? = bluetoothAdapter?.bondedDevices
        device = pairedDevices?.find { it.name == "HC-05" || it.name == "HC-06" } // Adjust name if different
        if (device == null) {
            Toast.makeText(this, "No paired Bluetooth module (HC-05/HC-06) found", Toast.LENGTH_LONG).show()
            return
        }

        binding.connectionProgress.visibility = View.VISIBLE
        updateButtonStates(isConnecting = true)

        Thread {
            try {
                bluetoothSocket = device!!.createRfcommSocketToServiceRecord(uuid)
                bluetoothSocket?.connect()
                runOnUiThread {
                    binding.statusText.text = "Connected to ${device!!.name}"
                    binding.statusText.setTextColor(ContextCompat.getColor(this, android.R.color.holo_green_dark))
                    binding.connectionProgress.visibility = View.GONE
                    updateButtonStates(isConnected = true)
                }
            } catch (e: IOException) {
                runOnUiThread {
                    binding.statusText.text = "Disconnected"
                    binding.statusText.setTextColor(ContextCompat.getColor(this, android.R.color.holo_orange_dark))
                    binding.connectionProgress.visibility = View.GONE
                    updateButtonStates(isConnected = false)
                    Toast.makeText(this, "Connection failed: ${e.message}", Toast.LENGTH_SHORT).show()
                }
            }
        }.start()
    }

    private fun disconnectBluetooth() {
        try {
            bluetoothSocket?.close()
            binding.statusText.text = "Disconnected"
            binding.statusText.setTextColor(ContextCompat.getColor(this, android.R.color.holo_orange_dark))
            updateButtonStates(isConnected = false)
        } catch (e: IOException) {
            Toast.makeText(this, "Disconnect failed: ${e.message}", Toast.LENGTH_SHORT).show()
        }
    }

    private fun updateButtonStates(isConnected: Boolean = false, isConnecting: Boolean = false) {
        binding.connectButton.isEnabled = !isConnected && !isConnecting
        binding.disconnectButton.isEnabled = isConnected && !isConnecting
        binding.connectionProgress.visibility = if (isConnecting) View.VISIBLE else View.GONE
    }

    private fun sendCommand(command: String) {
        if (bluetoothSocket?.isConnected == true) {
            try {
                bluetoothSocket?.outputStream?.write(command.toByteArray())
            } catch (e: IOException) {
                Toast.makeText(this, "Failed to send command: ${e.message}", Toast.LENGTH_SHORT).show()
            }
        } else {
            Toast.makeText(this, "Bluetooth not connected", Toast.LENGTH_SHORT).show()
        }
    }

    private fun setupButtonListeners() {
        binding.forwardButton.setOnClickListener { sendCommand("F") }
        binding.backwardButton.setOnClickListener { sendCommand("B") }
        binding.leftButton.setOnClickListener { sendCommand("L") }
        binding.rightButton.setOnClickListener { sendCommand("R") }
        binding.stopButton.setOnClickListener { sendCommand("S") }
        binding.voiceButton.setOnClickListener { startVoiceRecognition() }
    }

    private fun startVoiceRecognition() {
        val intent = Intent(RecognizerIntent.ACTION_RECOGNIZE_SPEECH).apply {
            putExtra(RecognizerIntent.EXTRA_LANGUAGE_MODEL, RecognizerIntent.LANGUAGE_MODEL_FREE_FORM)
            putExtra(RecognizerIntent.EXTRA_PROMPT, "Say: Forward, Backward, Left, Right, Stop")
        }
        voiceRecognitionLauncher.launch(intent)
    }

    private val voiceRecognitionLauncher = registerForActivityResult(ActivityResultContracts.StartActivityForResult()) { result ->
        if (result.resultCode == RESULT_OK) {
            val spokenText = result.data?.getStringArrayListExtra(RecognizerIntent.EXTRA_RESULTS)?.get(0)?.lowercase()
            binding.voiceResultText.text = spokenText ?: "Recognition failed"
            when {
                spokenText?.contains("forward") == true -> sendCommand("F")
                spokenText?.contains("backward") == true -> sendCommand("B")
                spokenText?.contains("left") == true -> sendCommand("L")
                spokenText?.contains("right") == true -> sendCommand("R")
                spokenText?.contains("stop") == true -> sendCommand("S")
                else -> Toast.makeText(this, "Command not recognized", Toast.LENGTH_SHORT).show()
            }
        }
    }

    override fun onDestroy() {
        super.onDestroy()
        try {
            bluetoothSocket?.close()
        } catch (e: IOException) {
            e.printStackTrace()
        }
    }
}