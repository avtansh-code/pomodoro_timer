package com.pomodoro.timer.ui.screens.statistics

import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material3.Card
import androidx.compose.material3.CardDefaults
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Tab
import androidx.compose.material3.TabRow
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.collectAsState
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableIntStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.semantics.heading
import androidx.compose.ui.semantics.semantics
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.dp
import androidx.hilt.navigation.compose.hiltViewModel
import com.pomodoro.timer.domain.model.SessionType
import com.pomodoro.timer.domain.model.TimerSession
import com.pomodoro.timer.presentation.viewmodel.StatisticsViewModel
import com.pomodoro.timer.ui.theme.PomodoroTheme
import java.text.SimpleDateFormat
import java.util.Date
import java.util.Locale

/**
 * Statistics Screen matching iOS StatisticsView functionality.
 */
@Composable
fun StatisticsScreen(
    viewModel: StatisticsViewModel = hiltViewModel()
) {
    var selectedPeriod by remember { mutableIntStateOf(0) }
    val periods = listOf("Today", "Week", "Month", "All Time")
    
    val statistics by when (selectedPeriod) {
        0 -> viewModel.todayStatistics
        1 -> viewModel.weekStatistics
        2 -> viewModel.monthStatistics
        else -> viewModel.allTimeStatistics
    }.collectAsState()
    
    val streak by viewModel.currentStreak.collectAsState()
    val recentSessions by viewModel.recentSessions.collectAsState()
    
    Column(
        modifier = Modifier
            .fillMaxSize()
            .padding(horizontal = 16.dp, vertical = 24.dp)
    ) {
        // Screen Title with proper semantics
        Text(
            text = "Statistics",
            style = MaterialTheme.typography.headlineLarge,
            fontWeight = FontWeight.Bold,
            color = MaterialTheme.colorScheme.onBackground,
            modifier = Modifier
                .padding(bottom = 24.dp)
                .semantics { heading() }
        )
        
        // Period Selector with Material 3 styling
        TabRow(
            selectedTabIndex = selectedPeriod,
            containerColor = MaterialTheme.colorScheme.surface,
            contentColor = MaterialTheme.colorScheme.primary
        ) {
            periods.forEachIndexed { index, title ->
                Tab(
                    selected = selectedPeriod == index,
                    onClick = { selectedPeriod = index },
                    text = {
                        Text(
                            text = title,
                            style = MaterialTheme.typography.labelLarge
                        )
                    }
                )
            }
        }
        
        Spacer(modifier = Modifier.height(32.dp))
        
        // Statistics Cards
        Row(
            modifier = Modifier.fillMaxWidth(),
            horizontalArrangement = Arrangement.spacedBy(12.dp)
        ) {
            StatCard(
                title = "Sessions",
                value = statistics.totalSessions.toString(),
                modifier = Modifier.weight(1f)
            )
            
            StatCard(
                title = "Time",
                value = formatMinutes(statistics.totalMinutes.toLong()),
                modifier = Modifier.weight(1f)
            )
        }
        
        Spacer(modifier = Modifier.height(12.dp))
        
        Row(
            modifier = Modifier.fillMaxWidth(),
            horizontalArrangement = Arrangement.spacedBy(12.dp)
        ) {
            StatCard(
                title = "Avg Session",
                value = formatMinutes(statistics.averageSessionMinutes.toLong()),
                modifier = Modifier.weight(1f)
            )
            
            StatCard(
                title = "Streak",
                value = "$streak days",
                modifier = Modifier.weight(1f)
            )
        }
        
        Spacer(modifier = Modifier.height(32.dp))
        
        // Recent Sessions header with semantics
        Text(
            text = "Recent Sessions",
            style = MaterialTheme.typography.titleMedium,
            fontWeight = FontWeight.SemiBold,
            color = MaterialTheme.colorScheme.onBackground,
            modifier = Modifier
                .padding(bottom = 12.dp)
                .semantics { heading() }
        )
        
        LazyColumn(
            verticalArrangement = Arrangement.spacedBy(8.dp)
        ) {
            if (recentSessions.isEmpty()) {
                item {
                    Text(
                        text = "No sessions yet. Start your first Pomodoro!",
                        style = MaterialTheme.typography.bodyMedium,
                        color = MaterialTheme.colorScheme.onSurfaceVariant,
                        modifier = Modifier.padding(vertical = 32.dp)
                    )
                }
            } else {
                items(recentSessions) { session ->
                    SessionItem(session = session)
                }
            }
        }
    }
}

@Composable
private fun StatCard(
    title: String,
    value: String,
    modifier: Modifier = Modifier
) {
    Card(
        modifier = modifier.semantics(mergeDescendants = true) {},
        colors = CardDefaults.cardColors(
            containerColor = MaterialTheme.colorScheme.primaryContainer
        ),
        shape = RoundedCornerShape(16.dp),
        elevation = CardDefaults.cardElevation(defaultElevation = 2.dp)
    ) {
        Column(
            modifier = Modifier
                .fillMaxWidth()
                .padding(20.dp),
            horizontalAlignment = Alignment.CenterHorizontally
        ) {
            Text(
                text = value,
                style = MaterialTheme.typography.headlineMedium,
                fontWeight = FontWeight.Bold,
                color = MaterialTheme.colorScheme.onPrimaryContainer
            )
            
            Spacer(modifier = Modifier.height(8.dp))
            
            Text(
                text = title,
                style = MaterialTheme.typography.bodyMedium,
                color = MaterialTheme.colorScheme.onPrimaryContainer.copy(alpha = 0.8f)
            )
        }
    }
}

@Composable
private fun SessionItem(session: TimerSession) {
    Card(
        modifier = Modifier
            .fillMaxWidth()
            .semantics(mergeDescendants = true) {},
        colors = CardDefaults.cardColors(
            containerColor = MaterialTheme.colorScheme.surfaceVariant.copy(alpha = 0.5f)
        ),
        shape = RoundedCornerShape(16.dp),
        elevation = CardDefaults.cardElevation(defaultElevation = 0.dp)
    ) {
        Row(
            modifier = Modifier
                .fillMaxWidth()
                .padding(16.dp),
            horizontalArrangement = Arrangement.SpaceBetween,
            verticalAlignment = Alignment.CenterVertically
        ) {
            Column(modifier = Modifier.weight(1f)) {
                Text(
                    text = session.type.name.lowercase()
                        .replaceFirstChar { it.uppercase() }
                        .replace("_", " "),
                    style = MaterialTheme.typography.bodyLarge,
                    fontWeight = FontWeight.Medium,
                    color = MaterialTheme.colorScheme.onSurface
                )
                
                Spacer(modifier = Modifier.height(4.dp))
                
                Text(
                    text = formatTimestamp(session.completedAt),
                    style = MaterialTheme.typography.bodyMedium,
                    color = MaterialTheme.colorScheme.onSurfaceVariant
                )
            }
            
            Text(
                text = "${session.duration / 60} min",
                style = MaterialTheme.typography.bodyLarge,
                fontWeight = FontWeight.SemiBold,
                color = MaterialTheme.colorScheme.primary
            )
        }
    }
}

private fun formatMinutes(minutes: Long): String {
    return when {
        minutes < 60 -> "${minutes}m"
        else -> {
            val hours = minutes / 60
            val remainingMinutes = minutes % 60
            if (remainingMinutes == 0L) "${hours}h" else "${hours}h ${remainingMinutes}m"
        }
    }
}

private fun formatTimestamp(timestamp: Long): String {
    val sdf = SimpleDateFormat("MMM dd, h:mm a", Locale.getDefault())
    return sdf.format(Date(timestamp))
}

@Preview(showBackground = true)
@Composable
private fun StatCardPreview() {
    PomodoroTheme {
        StatCard(
            title = "Sessions",
            value = "12"
        )
    }
}

@Preview(showBackground = true)
@Composable
private fun SessionItemPreview() {
    PomodoroTheme {
        SessionItem(
            session = TimerSession(
                id = "1",
                type = SessionType.FOCUS,
                duration = 1500,
                completedAt = System.currentTimeMillis(),
                wasCompleted = true
            )
        )
    }
}

@Preview(showBackground = true)
@Composable
private fun StatCardsRowPreview() {
    PomodoroTheme {
        Row(
            modifier = Modifier
                .fillMaxWidth()
                .padding(16.dp),
            horizontalArrangement = Arrangement.spacedBy(12.dp)
        ) {
            StatCard(
                title = "Sessions",
                value = "8",
                modifier = Modifier.weight(1f)
            )
            
            StatCard(
                title = "Time",
                value = "3h 20m",
                modifier = Modifier.weight(1f)
            )
        }
    }
}
