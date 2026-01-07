package com.avtanshgupta.mr.pomodoro.ui.screens.privacy

import androidx.compose.foundation.background
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.foundation.verticalScroll
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.automirrored.filled.ArrowBack
import androidx.compose.material.icons.filled.CheckCircle
import androidx.compose.material.icons.filled.Info
import androidx.compose.material.icons.filled.Shield
import androidx.compose.material3.*
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.dp
import com.avtanshgupta.mr.pomodoro.ui.theme.PomodoroTheme

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun PrivacyPolicyScreen(
    onBackClick: () -> Unit
) {
    Scaffold(
        topBar = {
            TopAppBar(
                title = { 
                    Text(
                        "Privacy Policy",
                        style = MaterialTheme.typography.titleLarge,
                        fontWeight = FontWeight.Bold
                    ) 
                },
                navigationIcon = {
                    IconButton(onClick = onBackClick) {
                        Icon(
                            imageVector = Icons.AutoMirrored.Filled.ArrowBack,
                            contentDescription = "Back"
                        )
                    }
                },
                colors = TopAppBarDefaults.topAppBarColors(
                    containerColor = MaterialTheme.colorScheme.surface
                )
            )
        }
    ) { paddingValues ->
        Column(
            modifier = Modifier
                .fillMaxSize()
                .padding(paddingValues)
                .verticalScroll(rememberScrollState())
                .padding(16.dp),
            verticalArrangement = Arrangement.spacedBy(16.dp)
        ) {
            PrivacyPolicyContent()
        }
    }
}

@Composable
private fun PrivacyPolicyContent() {
    // Hero Card
    HeroCard()
    
    // Privacy Commitment Card
    PrivacyCommitmentCard()
    
    // What We Collect Section
    SectionCard(
        title = "What Data We Collect",
        icon = Icons.Default.Info
    ) {
        BoldBodyText("Locally Stored Data")
        BodyText("The app stores the following information locally on your device only:")
        BulletPoint("Timer Settings: Your preferences for focus duration, break lengths, sessions, and theme")
        BulletPoint("Session History: Records of completed Pomodoro sessions")
        BulletPoint("Statistics: Calculated metrics like daily streaks and totals")
    }
    
    // What We Don't Collect Section
    SectionCard(
        title = "What We DO NOT Collect",
        icon = Icons.Default.Shield,
        containerColor = MaterialTheme.colorScheme.errorContainer,
        contentColor = MaterialTheme.colorScheme.onErrorContainer
    ) {
        NegativeBulletPoint("No Analytics or Tracking")
        NegativeBulletPoint("No Third-Party Services")
        NegativeBulletPoint("No Advertising")
        NegativeBulletPoint("No Account Creation")
        NegativeBulletPoint("No Network Requests")
        NegativeBulletPoint("No Location Data")
        NegativeBulletPoint("No Contact Information")
        NegativeBulletPoint("No Camera or Photos")
    }
    
    // How Data Is Used
    SectionCard(
        title = "How Your Data Is Used",
        icon = Icons.Default.CheckCircle
    ) {
        BodyText("All data collected is used solely to:")
        BulletPoint("Display your timer settings and preferences")
        BulletPoint("Show your productivity statistics and session history")
        BulletPoint("Calculate streaks and performance metrics")
        BulletPoint("Enable app shortcuts and automation")
    }
    
    // Data Storage and Security
    SectionCard(
        title = "Data Storage and Security"
    ) {
        BoldBodyText("Local Storage")
        BulletPoint("All data stored locally using Android's Room database")
        BulletPoint("Protected by Android sandboxing and device security")
        BulletPoint("Automatically backed up with device backup settings")
        
        Spacer(modifier = Modifier.height(12.dp))
        
        BoldBodyText("Security Measures")
        BulletPoint("Android sandboxing prevents other apps from accessing data")
        BulletPoint("No passwords or sensitive personal information stored")
    }
    
    // Data Retention and Deletion
    SectionCard(title = "Data Retention and Deletion") {
        BoldBodyText("Automatic Deletion")
        BulletPoint("Data automatically deleted when you uninstall the app")
        BulletPoint("Clearing app data removes all local data")
        
        Spacer(modifier = Modifier.height(12.dp))
        
        BoldBodyText("Manual Deletion")
        BodyText("You can delete your data at any time:")
        BulletPoint("Clear session history through Statistics screen")
        BulletPoint("Reset settings to defaults in Settings")
        BulletPoint("Uninstall app to remove all data")
    }
    
    // Your Rights and Control
    SectionCard(title = "Your Rights and Control") {
        BulletPoint("Access: View all your settings and session history")
        BulletPoint("Modify: Edit or update preferences at any time")
        BulletPoint("Delete: Clear session history or reset data")
        BulletPoint("Export: View session data in Statistics screen")
    }
    
    // Permissions
    SectionCard(title = "Notifications and Permissions") {
        BodyText("The app may request:")
        BulletPoint("Notifications: Alert when timer sessions complete (optional)")
        BulletPoint("Foreground Service: Keep timer running in background")
        
        Spacer(modifier = Modifier.height(8.dp))
        BodyText("All permissions are optional and managed in Android Settings.")
    }
    
    // Children's Privacy
    SectionCard(title = "Children's Privacy") {
        BodyText(
            "Pomodoro Timer is not directed at children under 13. We do not knowingly " +
            "collect personal information from children. The app contains no social features, " +
            "external links, or third-party content."
        )
    }
    
    // Compliance
    SectionCard(title = "Compliance") {
        BoldBodyText("GDPR (General Data Protection Regulation)")
        BodyText("For users in the European Union:")
        BulletPoint("Data processed on basis of legitimate interest and consent")
        BulletPoint("Right to access, rectify, erase, and port your data")
        BulletPoint("All data remains on your device")
        
        Spacer(modifier = Modifier.height(12.dp))
        
        BoldBodyText("CCPA (California Consumer Privacy Act)")
        BodyText("For California residents:")
        BulletPoint("We do not sell personal information")
        BulletPoint("No sharing for cross-context behavioral advertising")
        BulletPoint("Right to know what data is collected and delete it")
    }
    
    // Changes to Policy
    SectionCard(title = "Changes to This Privacy Policy") {
        BodyText("We may update this Privacy Policy to reflect:")
        BulletPoint("Changes in privacy laws or regulations")
        BulletPoint("Updates to app features or functionality")
        BulletPoint("Improvements to our privacy practices")
        
        Spacer(modifier = Modifier.height(12.dp))
        BodyText("When we make changes:")
        BulletPoint("\"Last Updated\" date will be revised")
        BulletPoint("Significant changes communicated via in-app notification")
        BulletPoint("Continued use indicates acceptance")
    }
    
    // Contact
    SectionCard(title = "Contact Us") {
        BodyText("Questions or concerns about this Privacy Policy?")
        BulletPoint("Email: support@pomodorotimer.in")
        BulletPoint("Response Time: Within 48 hours")
    }
    
    // Summary Card
    SummaryCard()
    
    Spacer(modifier = Modifier.height(16.dp))
}

@Composable
private fun HeroCard() {
    Card(
        modifier = Modifier.fillMaxWidth(),
        colors = CardDefaults.cardColors(
            containerColor = MaterialTheme.colorScheme.primaryContainer
        ),
        shape = RoundedCornerShape(20.dp)
    ) {
        Column(
            modifier = Modifier.padding(24.dp),
            horizontalAlignment = Alignment.CenterHorizontally
        ) {
            Icon(
                imageVector = Icons.Default.Shield,
                contentDescription = null,
                modifier = Modifier.size(48.dp),
                tint = MaterialTheme.colorScheme.primary
            )
            
            Spacer(modifier = Modifier.height(16.dp))
            
            Text(
                text = "Privacy Policy",
                style = MaterialTheme.typography.headlineMedium,
                fontWeight = FontWeight.Bold,
                color = MaterialTheme.colorScheme.onPrimaryContainer,
                modifier = Modifier.fillMaxWidth(),
                textAlign = androidx.compose.ui.text.style.TextAlign.Center
            )
            
            Spacer(modifier = Modifier.height(8.dp))
            
            Text(
                text = "Mr. Pomodoro",
                style = MaterialTheme.typography.titleMedium,
                color = MaterialTheme.colorScheme.onPrimaryContainer,
                modifier = Modifier.fillMaxWidth(),
                textAlign = androidx.compose.ui.text.style.TextAlign.Center
            )
            
            Spacer(modifier = Modifier.height(4.dp))
            
            Text(
                text = "Effective Date: October 25, 2025",
                style = MaterialTheme.typography.bodySmall,
                color = MaterialTheme.colorScheme.onPrimaryContainer.copy(alpha = 0.7f),
                modifier = Modifier.fillMaxWidth(),
                textAlign = androidx.compose.ui.text.style.TextAlign.Center
            )
            
            Text(
                text = "Last Updated: October 29, 2025",
                style = MaterialTheme.typography.bodySmall,
                color = MaterialTheme.colorScheme.onPrimaryContainer.copy(alpha = 0.7f),
                modifier = Modifier.fillMaxWidth(),
                textAlign = androidx.compose.ui.text.style.TextAlign.Center
            )
        }
    }
}

@Composable
private fun PrivacyCommitmentCard() {
    Card(
        modifier = Modifier.fillMaxWidth(),
        colors = CardDefaults.cardColors(
            containerColor = MaterialTheme.colorScheme.secondaryContainer
        ),
        shape = RoundedCornerShape(16.dp)
    ) {
        Column(modifier = Modifier.padding(20.dp)) {
            Row(verticalAlignment = Alignment.CenterVertically) {
                Icon(
                    imageVector = Icons.Default.CheckCircle,
                    contentDescription = null,
                    tint = MaterialTheme.colorScheme.secondary,
                    modifier = Modifier.size(24.dp)
                )
                Spacer(modifier = Modifier.width(12.dp))
                Text(
                    text = "Our Commitment to Privacy",
                    style = MaterialTheme.typography.titleMedium,
                    fontWeight = FontWeight.Bold,
                    color = MaterialTheme.colorScheme.onSecondaryContainer
                )
            }
            
            Spacer(modifier = Modifier.height(12.dp))
            
            Text(
                text = "Mr. Pomodoro is designed with privacy as a core principle. " +
                        "Your productivity data remains yours, stored securely on your device. " +
                        "We are committed to protecting your privacy and being transparent about " +
                        "our data practices.",
                style = MaterialTheme.typography.bodyMedium,
                color = MaterialTheme.colorScheme.onSecondaryContainer
            )
        }
    }
}

@Composable
private fun SectionCard(
    title: String,
    icon: androidx.compose.ui.graphics.vector.ImageVector? = null,
    containerColor: androidx.compose.ui.graphics.Color = MaterialTheme.colorScheme.surfaceVariant,
    contentColor: androidx.compose.ui.graphics.Color = MaterialTheme.colorScheme.onSurfaceVariant,
    content: @Composable ColumnScope.() -> Unit
) {
    Card(
        modifier = Modifier.fillMaxWidth(),
        colors = CardDefaults.cardColors(
            containerColor = containerColor
        ),
        shape = RoundedCornerShape(16.dp)
    ) {
        Column(modifier = Modifier.padding(20.dp)) {
            Row(
                verticalAlignment = Alignment.CenterVertically,
                modifier = Modifier.padding(bottom = 12.dp)
            ) {
                if (icon != null) {
                    Icon(
                        imageVector = icon,
                        contentDescription = null,
                        tint = contentColor,
                        modifier = Modifier.size(24.dp)
                    )
                    Spacer(modifier = Modifier.width(12.dp))
                }
                Text(
                    text = title,
                    style = MaterialTheme.typography.titleMedium,
                    fontWeight = FontWeight.Bold,
                    color = contentColor
                )
            }
            
            content()
        }
    }
}

@Composable
private fun SummaryCard() {
    Card(
        modifier = Modifier.fillMaxWidth(),
        colors = CardDefaults.cardColors(
            containerColor = MaterialTheme.colorScheme.tertiaryContainer
        ),
        shape = RoundedCornerShape(16.dp)
    ) {
        Column(modifier = Modifier.padding(20.dp)) {
            Text(
                text = "Summary",
                style = MaterialTheme.typography.titleLarge,
                fontWeight = FontWeight.Bold,
                color = MaterialTheme.colorScheme.onTertiaryContainer,
                modifier = Modifier.padding(bottom = 12.dp)
            )
            
            BulletPoint("✅ What We Collect: Timer settings and session history stored locally")
            BulletPoint("🔒 What We Don't: No analytics, tracking, or personal information")
            BulletPoint("👤 Your Control: Full control to view, modify, and delete all data")
            BulletPoint("🛡️ Privacy First: Designed to keep your productivity data private")
        }
    }
}

// Typography Components
@Composable
private fun BoldBodyText(text: String) {
    Text(
        text = text,
        style = MaterialTheme.typography.bodyLarge,
        fontWeight = FontWeight.Bold,
        modifier = Modifier.padding(bottom = 8.dp, top = 4.dp)
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
    Row(
        modifier = Modifier.padding(start = 8.dp, bottom = 6.dp, top = 2.dp)
    ) {
        Text(
            "• ",
            style = MaterialTheme.typography.bodyMedium,
            color = MaterialTheme.colorScheme.primary,
            fontWeight = FontWeight.Bold
        )
        Text(
            text = text,
            style = MaterialTheme.typography.bodyMedium,
            color = MaterialTheme.colorScheme.onSurfaceVariant
        )
    }
}

@Composable
private fun NegativeBulletPoint(text: String) {
    Row(
        modifier = Modifier.padding(start = 8.dp, bottom = 6.dp, top = 2.dp)
    ) {
        Text(
            "❌ ",
            style = MaterialTheme.typography.bodyMedium
        )
        Text(
            text = text,
            style = MaterialTheme.typography.bodyMedium,
            color = MaterialTheme.colorScheme.onErrorContainer
        )
    }
}

@Preview(showBackground = true)
@Composable
private fun PrivacyPolicyScreenPreview() {
    PomodoroTheme {
        PrivacyPolicyScreen(
            onBackClick = {}
        )
    }
}

@Preview(showBackground = true, uiMode = android.content.res.Configuration.UI_MODE_NIGHT_YES)
@Composable
private fun PrivacyPolicyScreenDarkPreview() {
    PomodoroTheme {
        PrivacyPolicyScreen(
            onBackClick = {}
        )
    }
}
