package com.pomodoro.timer.ui.screens.privacy

import androidx.compose.foundation.layout.*
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.verticalScroll
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.automirrored.filled.ArrowBack
import androidx.compose.material3.*
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.dp
import com.pomodoro.timer.ui.theme.PomodoroTheme

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun PrivacyPolicyScreen(
    onBackClick: () -> Unit
) {
    Scaffold(
        topBar = {
            TopAppBar(
                title = { Text("Privacy Policy") },
                navigationIcon = {
                    IconButton(onClick = onBackClick) {
                        Icon(
                            imageVector = Icons.AutoMirrored.Filled.ArrowBack,
                            contentDescription = "Back"
                        )
            }
        }
    }
}

@Preview(showBackground = true)
@Composable
private fun PrivacyPolicyScreenPreview() {
    PomodoroTheme {
        PrivacyPolicyScreen(
            onNavigateBack = {}
        )
    }
}

@Preview(showBackground = true, uiMode = android.content.res.Configuration.UI_MODE_NIGHT_YES)
@Composable
private fun PrivacyPolicyScreenDarkPreview() {
    PomodoroTheme {
        PrivacyPolicyScreen(
            onNavigateBack = {}
        )
    }
}
    ) { paddingValues ->
        Column(
            modifier = Modifier
                .fillMaxSize()
                .padding(paddingValues)
                .verticalScroll(rememberScrollState())
                .padding(16.dp)
        ) {
            PrivacyPolicyContent()
        }
    }
}

@Composable
private fun PrivacyPolicyContent() {
    // Header
    SectionTitle("Privacy Policy for Mr. Pomodoro")
    BodyText("Effective Date: October 27, 2025")
    BodyText("Last Updated: October 27, 2025")
    
    Spacer(modifier = Modifier.height(24.dp))
    
    // Introduction
    SubsectionTitle("Introduction")
    BodyText(
        "Welcome to Mr. Pomodoro (\"we,\" \"our,\" or \"the app\"). We are committed to " +
        "protecting your privacy and being transparent about how we handle your information. " +
        "This Privacy Policy explains our practices regarding data collection, use, and storage."
    )
    
    Spacer(modifier = Modifier.height(16.dp))
    
    // Our Commitment
    SubsectionTitle("Our Commitment to Privacy")
    BodyText(
        "Mr. Pomodoro is designed with privacy as a core principle. We believe your " +
        "productivity data should remain yours, stored securely on your device."
    )
    
    Spacer(modifier = Modifier.height(16.dp))
    
    // What We Collect
    SubsectionTitle("What Data We Collect")
    BoldBodyText("Locally Stored Data")
    BodyText("The app stores the following information locally on your device only:")
    BulletPoint("Timer Settings: Your preferences for focus duration, break lengths, number of sessions, sound/haptic settings, theme preferences, and notification settings")
    BulletPoint("Session History: Records of completed Pomodoro sessions including session type (focus/break), duration, and completion timestamp")
    BulletPoint("Statistics: Calculated metrics derived from your session history (daily streaks, weekly/monthly totals)")
    
    Spacer(modifier = Modifier.height(16.dp))
    
    // What We Don't Collect
    SubsectionTitle("What We DO NOT Collect")
    BodyText("We want to be crystal clear about what we don't do:")
    NegativeBulletPoint("No Analytics or Tracking: We do not use any analytics services or tracking tools")
    NegativeBulletPoint("No Third-Party Services: We do not share data with any third parties")
    NegativeBulletPoint("No Advertising: We do not collect data for advertising purposes")
    NegativeBulletPoint("No Account Creation: No email, username, or personal identification is required")
    NegativeBulletPoint("No Network Requests: The app does not make network requests")
    NegativeBulletPoint("No Location Data: We do not collect or access your location")
    NegativeBulletPoint("No Contact Information: We do not access your contacts")
    NegativeBulletPoint("No Camera or Photos: We do not access your camera or photo library")
    
    Spacer(modifier = Modifier.height(16.dp))
    
    // How Data Is Used
    SubsectionTitle("How Your Data Is Used")
    BodyText("All data collected is used solely to:")
    BulletPoint("Display your timer settings and preferences")
    BulletPoint("Show your productivity statistics and session history")
    BulletPoint("Calculate streaks and performance metrics")
    BulletPoint("Enable app shortcuts and automation")
    
    Spacer(modifier = Modifier.height(16.dp))
    
    // Data Storage
    SubsectionTitle("Data Storage and Security")
    BoldBodyText("Local Storage")
    BulletPoint("All data is stored locally using Android's Room database and DataStore")
    BulletPoint("Data is protected by Android sandboxing and your device's security features")
    BulletPoint("Data is automatically backed up with your device's backup (controlled by your device settings)")
    
    Spacer(modifier = Modifier.height(12.dp))
    
    BoldBodyText("Data Security Measures")
    BulletPoint("Android sandboxing prevents other apps from accessing Pomodoro Timer data")
    BulletPoint("No passwords or sensitive personal information is stored")
    
    Spacer(modifier = Modifier.height(16.dp))
    
    // Data Retention
    SubsectionTitle("Data Retention and Deletion")
    BoldBodyText("Automatic Deletion")
    BulletPoint("Data is automatically deleted when you uninstall the app")
    BulletPoint("Clearing app data in Android Settings removes all local data")
    
    Spacer(modifier = Modifier.height(12.dp))
    
    BoldBodyText("Manual Deletion")
    BodyText("You can delete your data at any time:")
    BulletPoint("Clear session history through the Statistics screen")
    BulletPoint("Reset all settings to defaults in the Settings screen")
    BulletPoint("Uninstall the app to remove all local data")
    
    Spacer(modifier = Modifier.height(16.dp))
    
    // Your Rights
    SubsectionTitle("Your Rights and Control")
    BodyText("You have complete control over your data:")
    BulletPoint("Access: View all your settings and session history within the app")
    BulletPoint("Modify: Edit or update your preferences at any time")
    BulletPoint("Delete: Clear session history or reset all data")
    BulletPoint("Export: Session data can be viewed in the Statistics screen")
    
    Spacer(modifier = Modifier.height(16.dp))
    
    // Permissions
    SubsectionTitle("Notifications and Permissions")
    BodyText("The app may request the following permissions:")
    BulletPoint("Notifications: To alert you when timer sessions complete (optional, can be disabled)")
    BulletPoint("Foreground Service: To keep timer running in background")
    
    Spacer(modifier = Modifier.height(8.dp))
    BodyText("All permissions are optional and can be managed in Android Settings.")
    
    Spacer(modifier = Modifier.height(16.dp))
    
    // Children's Privacy
    SubsectionTitle("Children's Privacy")
    BodyText(
        "Pomodoro Timer is not directed at children under 13 years of age. We do not knowingly " +
        "collect personal information from children. The app contains no social features, " +
        "external links, or third-party content that could expose children to risks."
    )
    
    Spacer(modifier = Modifier.height(16.dp))
    
    // Third-Party Services
    SubsectionTitle("Third-Party Services")
    BodyText("We do not use any third-party services, SDKs, or analytics tools.")
    
    Spacer(modifier = Modifier.height(16.dp))
    
    // Compliance
    SubsectionTitle("Compliance")
    BoldBodyText("GDPR (General Data Protection Regulation)")
    BodyText("For users in the European Union:")
    BulletPoint("We process data on the legal basis of legitimate interest and consent")
    BulletPoint("You have the right to access, rectify, erase, and port your data")
    BulletPoint("All data remains on your device")
    
    Spacer(modifier = Modifier.height(12.dp))
    
    BoldBodyText("CCPA (California Consumer Privacy Act)")
    BodyText("For California residents:")
    BulletPoint("We do not sell personal information")
    BulletPoint("We do not share personal information for cross-context behavioral advertising")
    BulletPoint("You have the right to know what data is collected and delete it")
    
    Spacer(modifier = Modifier.height(16.dp))
    
    // Changes
    SubsectionTitle("Changes to This Privacy Policy")
    BodyText("We may update this Privacy Policy from time to time to reflect:")
    BulletPoint("Changes in privacy laws or regulations")
    BulletPoint("Updates to app features or functionality")
    BulletPoint("Improvements to our privacy practices")
    
    Spacer(modifier = Modifier.height(12.dp))
    BodyText("When we make changes:")
    BulletPoint("The \"Last Updated\" date at the top will be revised")
    BulletPoint("Significant changes will be communicated through an in-app notification")
    BulletPoint("Continued use of the app after changes indicates acceptance")
    
    Spacer(modifier = Modifier.height(16.dp))
    
    // Contact
    SubsectionTitle("Contact Us")
    BodyText("If you have questions or concerns about this Privacy Policy or our data practices, please contact us:")
    BodyText("Email: support@pomodorotimer.in")
    BodyText("Response Time: We aim to respond within 48 hours")
    
    Spacer(modifier = Modifier.height(16.dp))
    
    // Your Consent
    SubsectionTitle("Your Consent")
    BodyText(
        "By using Pomodoro Timer, you consent to this Privacy Policy and our data practices " +
        "as described herein."
    )
    
    Spacer(modifier = Modifier.height(24.dp))
    
    // Summary
    Divider(modifier = Modifier.padding(vertical = 16.dp))
    
    SubsectionTitle("Summary")
    BulletPoint("What We Collect: Timer settings and session history stored locally on your device")
    BulletPoint("What We Don't Collect: No analytics, no tracking, no personal information, no third-party sharing")
    BulletPoint("Your Control: Full control to view, modify, and delete all data at any time")
    BulletPoint("Privacy First: Designed to keep your productivity data private and secure")
    
    Spacer(modifier = Modifier.height(32.dp))
}

// Typography Components
@Composable
private fun SectionTitle(text: String) {
    Text(
        text = text,
        style = MaterialTheme.typography.headlineMedium,
        fontWeight = FontWeight.Bold,
        modifier = Modifier.padding(bottom = 8.dp)
    )
}

@Composable
private fun SubsectionTitle(text: String) {
    Text(
        text = text,
        style = MaterialTheme.typography.titleLarge,
        fontWeight = FontWeight.Bold,
        modifier = Modifier.padding(bottom = 8.dp)
    )
}

@Composable
private fun BoldBodyText(text: String) {
    Text(
        text = text,
        style = MaterialTheme.typography.bodyLarge,
        fontWeight = FontWeight.Bold,
        modifier = Modifier.padding(bottom = 4.dp)
    )
}

@Composable
private fun BodyText(text: String) {
    Text(
        text = text,
        style = MaterialTheme.typography.bodyMedium,
        color = MaterialTheme.colorScheme.onSurfaceVariant,
        modifier = Modifier.padding(bottom = 8.dp)
    )
}

@Composable
private fun BulletPoint(text: String) {
    Row(modifier = Modifier.padding(start = 16.dp, bottom = 4.dp)) {
        Text("• ", style = MaterialTheme.typography.bodyMedium)
        Text(
            text = text,
            style = MaterialTheme.typography.bodyMedium,
            color = MaterialTheme.colorScheme.onSurfaceVariant
        )
    }
}

@Composable
private fun NegativeBulletPoint(text: String) {
    Row(modifier = Modifier.padding(start = 16.dp, bottom = 4.dp)) {
        Text("❌ ", style = MaterialTheme.typography.bodyMedium)
        Text(
            text = text,
            style = MaterialTheme.typography.bodyMedium,
            color = MaterialTheme.colorScheme.onSurfaceVariant
        )
    }
}
