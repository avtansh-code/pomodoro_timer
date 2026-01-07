package avtanshgupta.PomodoroTimer.ui.screens.benefits

import androidx.compose.foundation.background
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.foundation.verticalScroll
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.automirrored.filled.ArrowBack
import androidx.compose.material.icons.filled.PlayArrow
import androidx.compose.material3.*
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.graphics.Brush
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.text.font.FontStyle
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.dp
import avtanshgupta.PomodoroTimer.ui.theme.PomodoroTheme

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun PomodoroBenefitsScreen(
    onBackClick: () -> Unit,
    onGetStartedClick: () -> Unit
) {
    Scaffold(
        topBar = {
            TopAppBar(
                title = { Text("The Pomodoro Way") },
                navigationIcon = {
                    IconButton(onClick = onBackClick) {
                        Icon(
                            imageVector = Icons.AutoMirrored.Filled.ArrowBack,
                            contentDescription = "Back"
                        )
                    }
                }
            )
        }
    ) { paddingValues ->
        Box(
            modifier = Modifier
                .fillMaxSize()
                .padding(paddingValues)
        ) {
            // Background gradient
            Box(
                modifier = Modifier
                    .fillMaxSize()
                    .background(
                        Brush.verticalGradient(
                            colors = listOf(
                                MaterialTheme.colorScheme.primary.copy(alpha = 0.08f),
                                MaterialTheme.colorScheme.surface
                            )
                        )
                    )
            )
            
            Column(
                modifier = Modifier
                    .fillMaxSize()
                    .verticalScroll(rememberScrollState())
                    .padding(horizontal = 16.dp, vertical = 24.dp)
            ) {
                // Header Section
                HeaderSection()
                
                Spacer(modifier = Modifier.height(32.dp))
                
                // History Section
                HistorySection()
                
                Spacer(modifier = Modifier.height(32.dp))
                
                // How It Works Section
                HowItWorksSection()
                
                Spacer(modifier = Modifier.height(32.dp))
                
                // Benefits Section
                BenefitsSection()
                
                Spacer(modifier = Modifier.height(32.dp))
                
                // Considerations Section
                ConsiderationsSection()
                
                Spacer(modifier = Modifier.height(32.dp))
                
                // CTA Section
                CTASection(onGetStartedClick = onGetStartedClick)
                
                Spacer(modifier = Modifier.height(32.dp))
            }
        }
    }
}

@Composable
private fun HeaderSection() {
    Column(
        modifier = Modifier.fillMaxWidth(),
        horizontalAlignment = Alignment.CenterHorizontally
    ) {
        // Timer Icon
        Box(
            modifier = Modifier
                .size(100.dp)
                .clip(CircleShape)
                .background(MaterialTheme.colorScheme.primary.copy(alpha = 0.15f)),
            contentAlignment = Alignment.Center
        ) {
            Text(
                text = "⏲️",
                style = MaterialTheme.typography.displayMedium
            )
        }
        
        Spacer(modifier = Modifier.height(16.dp))
        
        Text(
            text = "The Power of Pomodoro",
            style = MaterialTheme.typography.headlineLarge,
            fontWeight = FontWeight.Bold,
            textAlign = TextAlign.Center
        )
        
        Spacer(modifier = Modifier.height(8.dp))
        
        Text(
            text = "Focus deeper. Work smarter. Rest better.",
            style = MaterialTheme.typography.titleMedium,
            color = MaterialTheme.colorScheme.onSurfaceVariant,
            textAlign = TextAlign.Center
        )
    }
}

@Composable
private fun HistorySection() {
    Column {
        SectionHeader(icon = "📚", title = "The Origin Story")
        
        Spacer(modifier = Modifier.height(16.dp))
        
        InfoCard {
            Column(verticalArrangement = Arrangement.spacedBy(12.dp)) {
                Text(
                    text = "The Pomodoro Technique was created in the late 1980s by Francesco Cirillo, an Italian university student seeking a better way to study and manage his time.",
                    style = MaterialTheme.typography.bodyMedium
                )
                
                Text(
                    text = "Named after the tomato-shaped kitchen timer (pomodoro means \"tomato\" in Italian) he used to track his work intervals, this simple yet powerful method has since helped millions worldwide achieve better focus and productivity.",
                    style = MaterialTheme.typography.bodyMedium
                )
                
                Row(
                    modifier = Modifier.padding(top = 4.dp),
                    horizontalArrangement = Arrangement.spacedBy(8.dp)
                ) {
                    Text(
                        text = "💡",
                        style = MaterialTheme.typography.bodyMedium
                    )
                    Text(
                        text = "Born from necessity, perfected through practice",
                        style = MaterialTheme.typography.bodyMedium,
                        fontStyle = FontStyle.Italic,
                        color = MaterialTheme.colorScheme.onSurfaceVariant
                    )
                }
            }
        }
    }
}

@Composable
private fun HowItWorksSection() {
    Column {
        SectionHeader(icon = "⚙️", title = "How It Works")
        
        Spacer(modifier = Modifier.height(8.dp))
        
        Text(
            text = "The technique is simple, sustainable, and scientifically backed:",
            style = MaterialTheme.typography.bodyMedium,
            color = MaterialTheme.colorScheme.onSurfaceVariant
        )
        
        Spacer(modifier = Modifier.height(12.dp))
        
        Column(verticalArrangement = Arrangement.spacedBy(12.dp)) {
            StepCard(
                number = 1,
                title = "Choose Your Task",
                description = "Select a single task or project you want to focus on.",
                icon = "✓",
                color = MaterialTheme.colorScheme.primary
            )
            
            StepCard(
                number = 2,
                title = "Set the Timer",
                description = "Start a 25-minute focus session (one \"pomodoro\").",
                icon = "⏲️",
                color = MaterialTheme.colorScheme.primary
            )
            
            StepCard(
                number = 3,
                title = "Work Without Distraction",
                description = "Focus entirely on your task until the timer rings.",
                icon = "🧠",
                color = MaterialTheme.colorScheme.primary
            )
            
            StepCard(
                number = 4,
                title = "Take a Short Break",
                description = "Rest for 5 minutes. Stretch, hydrate, or relax.",
                icon = "☕",
                color = Color(0xFF4CAF50)
            )
            
            StepCard(
                number = 5,
                title = "Repeat & Recharge",
                description = "After 4 pomodoros, take a longer 15-30 minute break.",
                icon = "🔄",
                color = Color(0xFF2196F3)
            )
        }
    }
}

@Composable
private fun BenefitsSection() {
    Column {
        SectionHeader(icon = "⭐", title = "Why It Works")
        
        Spacer(modifier = Modifier.height(8.dp))
        
        Text(
            text = "Research and millions of users have found these key benefits:",
            style = MaterialTheme.typography.bodyMedium,
            color = MaterialTheme.colorScheme.onSurfaceVariant
        )
        
        Spacer(modifier = Modifier.height(12.dp))
        
        Column(verticalArrangement = Arrangement.spacedBy(12.dp)) {
            BenefitCard(
                icon = "👁️",
                title = "Enhanced Focus",
                description = "Short, timed sessions help maintain deep concentration and prevent mental drift.",
                color = MaterialTheme.colorScheme.primary
            )
            
            BenefitCard(
                icon = "🔋",
                title = "Reduced Mental Fatigue",
                description = "Regular breaks prevent burnout and keep your mind fresh throughout the day.",
                color = Color(0xFF4CAF50)
            )
            
            BenefitCard(
                icon = "⏰",
                title = "Better Time Awareness",
                description = "Learn to accurately estimate how long tasks take and plan more effectively.",
                color = Color(0xFF2196F3)
            )
            
            BenefitCard(
                icon = "📈",
                title = "Increased Motivation",
                description = "Small wins and completed sessions create positive momentum and build confidence.",
                color = Color(0xFF9C27B0)
            )
            
            BenefitCard(
                icon = "🚶",
                title = "Sustainable Work Rhythm",
                description = "Balance focused work with restorative breaks for long-term productivity.",
                color = Color(0xFF00BCD4)
            )
            
            BenefitCard(
                icon = "🛑",
                title = "Distraction Management",
                description = "The commitment to 25 minutes helps you defer interruptions and stay on track.",
                color = Color(0xFFFF9800)
            )
        }
    }
}

@Composable
private fun ConsiderationsSection() {
    Column {
        SectionHeader(icon = "⚠️", title = "Things to Keep in Mind")
        
        Spacer(modifier = Modifier.height(16.dp))
        
        InfoCard {
            Column(verticalArrangement = Arrangement.spacedBy(12.dp)) {
                ConsiderationRow(
                    icon = "🔀",
                    text = "May interrupt deep creative flow states that benefit from longer unbroken periods."
                )
                
                HorizontalDivider()
                
                ConsiderationRow(
                    icon = "📅",
                    text = "The rigid structure might not suit all task types or work environments."
                )
                
                HorizontalDivider()
                
                ConsiderationRow(
                    icon = "👥",
                    text = "Collaborative work may require flexibility with timing to accommodate others."
                )
                
                HorizontalDivider()
                
                ConsiderationRow(
                    icon = "🎚️",
                    text = "Feel free to adjust session lengths to find what works best for you!"
                )
            }
        }
        
        Spacer(modifier = Modifier.height(12.dp))
        
        Text(
            text = "The Pomodoro Technique is a tool, not a rule. Adapt it to your needs and workflow.",
            style = MaterialTheme.typography.bodySmall,
            fontStyle = FontStyle.Italic,
            color = MaterialTheme.colorScheme.onSurfaceVariant,
            modifier = Modifier.padding(horizontal = 4.dp)
        )
    }
}

@Composable
private fun CTASection(onGetStartedClick: () -> Unit) {
    Column(
        modifier = Modifier.fillMaxWidth(),
        horizontalAlignment = Alignment.CenterHorizontally
    ) {
        Text(
            text = "Ready to experience the benefits?",
            style = MaterialTheme.typography.titleLarge,
            fontWeight = FontWeight.SemiBold,
            textAlign = TextAlign.Center
        )
        
        Spacer(modifier = Modifier.height(16.dp))
        
        Button(
            onClick = onGetStartedClick,
            modifier = Modifier
                .fillMaxWidth()
                .padding(horizontal = 8.dp),
            shape = RoundedCornerShape(12.dp),
            contentPadding = PaddingValues(vertical = 16.dp)
        ) {
            Icon(
                imageVector = Icons.Default.PlayArrow,
                contentDescription = null,
                modifier = Modifier.size(20.dp)
            )
            Spacer(modifier = Modifier.width(8.dp))
            Text(
                text = "Start Your First Pomodoro",
                style = MaterialTheme.typography.titleMedium,
                fontWeight = FontWeight.SemiBold
            )
        }
    }
}

// Supporting Composables

@Composable
private fun SectionHeader(icon: String, title: String) {
    Row(
        verticalAlignment = Alignment.CenterVertically,
        horizontalArrangement = Arrangement.spacedBy(12.dp)
    ) {
        Text(
            text = icon,
            style = MaterialTheme.typography.headlineSmall
        )
        Text(
            text = title,
            style = MaterialTheme.typography.headlineSmall,
            fontWeight = FontWeight.Bold
        )
    }
}

@Composable
private fun InfoCard(content: @Composable () -> Unit) {
    Surface(
        modifier = Modifier.fillMaxWidth(),
        shape = RoundedCornerShape(16.dp),
        tonalElevation = 2.dp,
        shadowElevation = 4.dp
    ) {
        Box(modifier = Modifier.padding(16.dp)) {
            content()
        }
    }
}

@Composable
private fun StepCard(
    number: Int,
    title: String,
    description: String,
    icon: String,
    color: Color
) {
    Surface(
        modifier = Modifier.fillMaxWidth(),
        shape = RoundedCornerShape(12.dp),
        tonalElevation = 1.dp,
        shadowElevation = 2.dp
    ) {
        Row(
            modifier = Modifier.padding(12.dp),
            horizontalArrangement = Arrangement.spacedBy(12.dp)
        ) {
            // Number circle
            Box(
                modifier = Modifier
                    .size(40.dp)
                    .clip(CircleShape)
                    .background(color.copy(alpha = 0.15f)),
                contentAlignment = Alignment.Center
            ) {
                Text(
                    text = number.toString(),
                    style = MaterialTheme.typography.titleMedium,
                    fontWeight = FontWeight.Bold,
                    color = color
                )
            }
            
            Column(
                modifier = Modifier.weight(1f),
                verticalArrangement = Arrangement.spacedBy(4.dp)
            ) {
                Row(
                    horizontalArrangement = Arrangement.spacedBy(6.dp),
                    verticalAlignment = Alignment.CenterVertically
                ) {
                    Text(text = icon, style = MaterialTheme.typography.bodyMedium)
                    Text(
                        text = title,
                        style = MaterialTheme.typography.titleSmall,
                        fontWeight = FontWeight.SemiBold
                    )
                }
                Text(
                    text = description,
                    style = MaterialTheme.typography.bodyMedium,
                    color = MaterialTheme.colorScheme.onSurfaceVariant
                )
            }
        }
    }
}

@Composable
private fun BenefitCard(
    icon: String,
    title: String,
    description: String,
    color: Color
) {
    Surface(
        modifier = Modifier.fillMaxWidth(),
        shape = RoundedCornerShape(12.dp),
        tonalElevation = 1.dp,
        shadowElevation = 2.dp
    ) {
        Row(
            modifier = Modifier.padding(12.dp),
            horizontalArrangement = Arrangement.spacedBy(12.dp)
        ) {
            // Icon box
            Box(
                modifier = Modifier
                    .size(44.dp)
                    .clip(RoundedCornerShape(10.dp))
                    .background(color.copy(alpha = 0.15f)),
                contentAlignment = Alignment.Center
            ) {
                Text(
                    text = icon,
                    style = MaterialTheme.typography.titleMedium
                )
            }
            
            Column(
                modifier = Modifier.weight(1f),
                verticalArrangement = Arrangement.spacedBy(4.dp)
            ) {
                Text(
                    text = title,
                    style = MaterialTheme.typography.titleSmall,
                    fontWeight = FontWeight.SemiBold
                )
                Text(
                    text = description,
                    style = MaterialTheme.typography.bodyMedium,
                    color = MaterialTheme.colorScheme.onSurfaceVariant
                )
            }
        }
    }
}

@Composable
private fun ConsiderationRow(icon: String, text: String) {
    Row(
        horizontalArrangement = Arrangement.spacedBy(12.dp),
        verticalAlignment = Alignment.Top
    ) {
        Text(
            text = icon,
            style = MaterialTheme.typography.bodyMedium,
            modifier = Modifier.width(24.dp)
        )
        Text(
            text = text,
            style = MaterialTheme.typography.bodyMedium,
            modifier = Modifier.weight(1f)
        )
    }
}

@Preview(showBackground = true)
@Composable
private fun PomodoroBenefitsScreenPreview() {
    PomodoroTheme {
        PomodoroBenefitsScreen(
            onBackClick = {},
            onGetStartedClick = {}
        )
    }
}

@Preview(showBackground = true, uiMode = android.content.res.Configuration.UI_MODE_NIGHT_YES)
@Composable
private fun PomodoroBenefitsScreenDarkPreview() {
    PomodoroTheme {
        PomodoroBenefitsScreen(
            onBackClick = {},
            onGetStartedClick = {}
        )
    }
}
