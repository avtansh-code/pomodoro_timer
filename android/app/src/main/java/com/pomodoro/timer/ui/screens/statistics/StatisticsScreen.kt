package com.pomodoro.timer.ui.screens.statistics

import androidx.compose.foundation.Canvas
import androidx.compose.foundation.background
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.foundation.verticalScroll
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.LocalFireDepartment
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.geometry.Offset
import androidx.compose.ui.geometry.Size
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.Path
import androidx.compose.ui.graphics.drawscope.Stroke
import androidx.compose.ui.graphics.nativeCanvas
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.dp
import androidx.hilt.navigation.compose.hiltViewModel
import com.pomodoro.timer.presentation.viewmodel.StatisticsViewModel
import com.pomodoro.timer.ui.theme.PomodoroTheme
import kotlin.math.cos
import kotlin.math.min
import kotlin.math.sin

enum class StatsPeriod {
    WEEK, MONTH
}

/**
 * Format seconds to mm:ss format
 */
private fun formatTimeMMSS(seconds: Long): String {
    val minutes = seconds / 60
    val secs = seconds % 60
    return String.format("%02d:%02d", minutes, secs)
}

@Composable
fun StatisticsScreen(
    viewModel: StatisticsViewModel = hiltViewModel()
) {
    var selectedPeriod by remember { mutableStateOf(StatsPeriod.WEEK) }
    
    val todayStats by viewModel.todayStatistics.collectAsState()
    val weekStats by viewModel.weekStatistics.collectAsState()
    val monthStats by viewModel.monthStatistics.collectAsState()
    val streak by viewModel.currentStreak.collectAsState()
    
    // Get actual data based on selected period
    val periodStats = if (selectedPeriod == StatsPeriod.WEEK) weekStats else monthStats
    
    // Calculate sessions per day data
    val sessionsPerDay = remember(periodStats) {
        // For now, use dummy data since we need daily breakdown
        // This would need to be implemented in the ViewModel with actual daily data
        List(if (selectedPeriod == StatsPeriod.WEEK) 7 else 30) { 0f }
    }
    
    val focusTimeTrend = remember(periodStats) {
        // For now, use dummy data since we need daily breakdown
        // This would need to be implemented in the ViewModel with actual daily data
        List(if (selectedPeriod == StatsPeriod.WEEK) 7 else 30) { 0f }
    }
    
    // Calculate pie chart data from period stats
    val focusMinutes = periodStats.focusSessionsCount * 25f // Assuming 25 min per focus session
    val shortBreakMinutes = periodStats.shortBreakSessionsCount * 5f
    val longBreakMinutes = periodStats.longBreakSessionsCount * 15f
    
    Column(
        modifier = Modifier
            .fillMaxSize()
            .verticalScroll(rememberScrollState())
            .padding(16.dp),
        verticalArrangement = Arrangement.spacedBy(16.dp)
    ) {
        // Title
        Text(
            text = "Statistics",
            style = MaterialTheme.typography.headlineMedium,
            fontWeight = FontWeight.Bold,
            modifier = Modifier.padding(vertical = 8.dp)
        )
        
        // Period Selector
        PeriodSelector(
            selectedPeriod = selectedPeriod,
            onPeriodSelected = { selectedPeriod = it }
        )
        
        // Streak Card
        StreakCard(streak = streak)
        
        // Today and Week Summary
        Row(
            modifier = Modifier.fillMaxWidth(),
            horizontalArrangement = Arrangement.spacedBy(12.dp)
        ) {
            SummaryCard(
                title = "Today",
                totalSessions = todayStats.totalSessions,
                focusSessions = todayStats.focusSessionsCount,
                focusTime = formatTimeMMSS(todayStats.focusDurationSeconds),
                breakTime = formatTimeMMSS(todayStats.shortBreakDurationSeconds + todayStats.longBreakDurationSeconds),
                modifier = Modifier.weight(1f)
            )
            
            SummaryCard(
                title = "Week",
                totalSessions = weekStats.totalSessions,
                focusSessions = weekStats.focusSessionsCount,
                focusTime = formatTimeMMSS(weekStats.focusDurationSeconds),
                breakTime = formatTimeMMSS(weekStats.shortBreakDurationSeconds + weekStats.longBreakDurationSeconds),
                modifier = Modifier.weight(1f)
            )
        }
        
        // Sessions Per Day Bar Chart
        ChartCard(title = "Sessions Per Day") {
            if (sessionsPerDay.any { it > 0f }) {
                BarChart(
                    data = sessionsPerDay,
                    modifier = Modifier
                        .fillMaxWidth()
                        .height(200.dp)
                )
            } else {
                Box(
                    modifier = Modifier
                        .fillMaxWidth()
                        .height(200.dp),
                    contentAlignment = Alignment.Center
                ) {
                    Text(
                        text = "No session data yet",
                        style = MaterialTheme.typography.bodyLarge,
                        color = MaterialTheme.colorScheme.onSurfaceVariant
                    )
                }
            }
        }
        
        // Focus Time Trend Line Chart
        ChartCard(title = "Focus Time Trend") {
            if (focusTimeTrend.any { it > 0f }) {
                LineChart(
                    data = focusTimeTrend,
                    modifier = Modifier
                        .fillMaxWidth()
                        .height(200.dp)
                )
            } else {
                Box(
                    modifier = Modifier
                        .fillMaxWidth()
                        .height(200.dp),
                    contentAlignment = Alignment.Center
                ) {
                    Text(
                        text = "No session data yet",
                        style = MaterialTheme.typography.bodyLarge,
                        color = MaterialTheme.colorScheme.onSurfaceVariant
                    )
                }
            }
        }
        
        // Session Distribution Pie Chart
        ChartCard(title = "Session Distribution") {
            if (focusMinutes + shortBreakMinutes + longBreakMinutes > 0) {
                PieChart(
                    focusMinutes = focusMinutes,
                    shortBreakMinutes = shortBreakMinutes,
                    longBreakMinutes = longBreakMinutes,
                    modifier = Modifier
                        .fillMaxWidth()
                        .height(250.dp)
                )
            } else {
                Box(
                    modifier = Modifier
                        .fillMaxWidth()
                        .height(250.dp),
                    contentAlignment = Alignment.Center
                ) {
                    Text(
                        text = "No session data yet",
                        style = MaterialTheme.typography.bodyLarge,
                        color = MaterialTheme.colorScheme.onSurfaceVariant
                    )
                }
            }
        }
        
        Spacer(modifier = Modifier.height(16.dp))
    }
}

@Composable
private fun PeriodSelector(
    selectedPeriod: StatsPeriod,
    onPeriodSelected: (StatsPeriod) -> Unit
) {
    Row(
        modifier = Modifier.fillMaxWidth(),
        horizontalArrangement = Arrangement.spacedBy(12.dp)
    ) {
        PeriodButton(
            text = "Last Week",
            selected = selectedPeriod == StatsPeriod.WEEK,
            onClick = { onPeriodSelected(StatsPeriod.WEEK) },
            modifier = Modifier.weight(1f)
        )
        
        PeriodButton(
            text = "Last Month",
            selected = selectedPeriod == StatsPeriod.MONTH,
            onClick = { onPeriodSelected(StatsPeriod.MONTH) },
            modifier = Modifier.weight(1f)
        )
    }
}

@Composable
private fun PeriodButton(
    text: String,
    selected: Boolean,
    onClick: () -> Unit,
    modifier: Modifier = Modifier
) {
    Button(
        onClick = onClick,
        modifier = modifier.height(48.dp),
        colors = ButtonDefaults.buttonColors(
            containerColor = if (selected) MaterialTheme.colorScheme.primary 
                           else MaterialTheme.colorScheme.surfaceVariant,
            contentColor = if (selected) MaterialTheme.colorScheme.onPrimary
                          else MaterialTheme.colorScheme.onSurfaceVariant
        ),
        shape = RoundedCornerShape(12.dp)
    ) {
        Text(
            text = text,
            style = MaterialTheme.typography.labelLarge,
            fontWeight = if (selected) FontWeight.Bold else FontWeight.Normal
        )
    }
}

@Composable
private fun StreakCard(streak: Int) {
    Card(
        modifier = Modifier.fillMaxWidth(),
        colors = CardDefaults.cardColors(
            containerColor = MaterialTheme.colorScheme.primaryContainer
        ),
        shape = RoundedCornerShape(20.dp)
    ) {
        Row(
            modifier = Modifier
                .fillMaxWidth()
                .padding(24.dp),
            verticalAlignment = Alignment.CenterVertically,
            horizontalArrangement = Arrangement.spacedBy(16.dp)
        ) {
            Icon(
                imageVector = Icons.Default.LocalFireDepartment,
                contentDescription = null,
                modifier = Modifier.size(48.dp),
                tint = MaterialTheme.colorScheme.primary
            )
            
            Column {
                Text(
                    text = "$streak Days",
                    style = MaterialTheme.typography.headlineMedium,
                    fontWeight = FontWeight.Bold,
                    color = MaterialTheme.colorScheme.onPrimaryContainer
                )
                Text(
                    text = "Current Streak",
                    style = MaterialTheme.typography.bodyMedium,
                    color = MaterialTheme.colorScheme.onPrimaryContainer.copy(alpha = 0.7f)
                )
            }
        }
    }
}

@Composable
private fun SummaryCard(
    title: String,
    totalSessions: Int,
    focusSessions: Int,
    focusTime: String,
    breakTime: String,
    modifier: Modifier = Modifier
) {
    Card(
        modifier = modifier,
        colors = CardDefaults.cardColors(
            containerColor = MaterialTheme.colorScheme.secondaryContainer
        ),
        shape = RoundedCornerShape(16.dp)
    ) {
        Column(
            modifier = Modifier.padding(16.dp),
            verticalArrangement = Arrangement.spacedBy(8.dp)
        ) {
            Text(
                text = title,
                style = MaterialTheme.typography.titleMedium,
                fontWeight = FontWeight.Bold,
                color = MaterialTheme.colorScheme.onSecondaryContainer
            )
            
            HorizontalDivider(color = MaterialTheme.colorScheme.onSecondaryContainer.copy(alpha = 0.2f))
            
            StatRow(label = "Total Sessions", value = totalSessions.toString())
            StatRow(label = "Focus Sessions", value = focusSessions.toString())
            StatRow(label = "Focus Time", value = focusTime)
            StatRow(label = "Break Time", value = breakTime)
        }
    }
}

@Composable
private fun StatRow(label: String, value: String) {
    Row(
        modifier = Modifier.fillMaxWidth(),
        horizontalArrangement = Arrangement.SpaceBetween
    ) {
        Text(
            text = label,
            style = MaterialTheme.typography.bodySmall,
            color = MaterialTheme.colorScheme.onSecondaryContainer.copy(alpha = 0.7f)
        )
        Text(
            text = value,
            style = MaterialTheme.typography.bodyMedium,
            fontWeight = FontWeight.SemiBold,
            color = MaterialTheme.colorScheme.onSecondaryContainer
        )
    }
}

@Composable
private fun ChartCard(
    title: String,
    content: @Composable () -> Unit
) {
    Card(
        modifier = Modifier.fillMaxWidth(),
        colors = CardDefaults.cardColors(
            containerColor = MaterialTheme.colorScheme.surfaceVariant
        ),
        shape = RoundedCornerShape(16.dp)
    ) {
        Column(
            modifier = Modifier.padding(20.dp)
        ) {
            Text(
                text = title,
                style = MaterialTheme.typography.titleMedium,
                fontWeight = FontWeight.Bold,
                color = MaterialTheme.colorScheme.onSurfaceVariant,
                modifier = Modifier.padding(bottom = 16.dp)
            )
            
            content()
        }
    }
}

@Composable
private fun BarChart(
    data: List<Float>,
    modifier: Modifier = Modifier
) {
    val primary = MaterialTheme.colorScheme.primary
    val onSurfaceVariant = MaterialTheme.colorScheme.onSurfaceVariant
    
    Canvas(modifier = modifier.padding(top = 8.dp, bottom = 16.dp)) {
        val maxValue = data.maxOrNull() ?: 1f
        val barWidth = size.width / (data.size * 2f)
        val spacing = barWidth * 0.5f
        
        data.forEachIndexed { index, value ->
            val barHeight = (value / maxValue) * (size.height - 40f)
            val left = index * (barWidth + spacing)
            
            drawRoundRect(
                color = primary,
                topLeft = Offset(left, size.height - barHeight - 20f),
                size = Size(barWidth, barHeight),
                cornerRadius = androidx.compose.ui.geometry.CornerRadius(4.dp.toPx())
            )
            
            // Draw value on top
            drawContext.canvas.nativeCanvas.apply {
                drawText(
                    value.toInt().toString(),
                    left + barWidth / 2f,
                    size.height - barHeight - 25f,
                    android.graphics.Paint().apply {
                        color = onSurfaceVariant.hashCode()
                        textSize = 24f
                        textAlign = android.graphics.Paint.Align.CENTER
                    }
                )
            }
        }
    }
}

@Composable
private fun LineChart(
    data: List<Float>,
    modifier: Modifier = Modifier
) {
    val primary = MaterialTheme.colorScheme.primary
    
    Canvas(modifier = modifier.padding(vertical = 16.dp)) {
        if (data.size < 2) return@Canvas
        
        val maxValue = data.maxOrNull() ?: 1f
        val minValue = data.minOrNull() ?: 0f
        val range = maxValue - minValue
        
        val stepX = size.width / (data.size - 1)
        val path = Path()
        
        data.forEachIndexed { index, value ->
            val x = index * stepX
            val y = size.height - ((value - minValue) / range) * size.height
            
            if (index == 0) {
                path.moveTo(x, y)
            } else {
                path.lineTo(x, y)
            }
            
            // Draw point
            drawCircle(
                color = primary,
                radius = 6.dp.toPx(),
                center = Offset(x, y)
            )
        }
        
        drawPath(
            path = path,
            color = primary,
            style = Stroke(width = 4.dp.toPx())
        )
    }
}

@Composable
private fun PieChart(
    focusMinutes: Float,
    shortBreakMinutes: Float,
    longBreakMinutes: Float,
    modifier: Modifier = Modifier
) {
    val total = focusMinutes + shortBreakMinutes + longBreakMinutes
    if (total == 0f) return
    
    val focusColor = MaterialTheme.colorScheme.primary
    val shortBreakColor = MaterialTheme.colorScheme.secondary
    val longBreakColor = MaterialTheme.colorScheme.tertiary
    
    Column(
        modifier = modifier,
        horizontalAlignment = Alignment.CenterHorizontally
    ) {
        Canvas(
            modifier = Modifier
                .size(180.dp)
                .padding(16.dp)
        ) {
            val radius = min(size.width, size.height) / 2f
            val centerX = size.width / 2f
            val centerY = size.height / 2f
            
            var startAngle = -90f
            
            // Focus
            val focusSweep = (focusMinutes / total) * 360f
            drawArc(
                color = focusColor,
                startAngle = startAngle,
                sweepAngle = focusSweep,
                useCenter = true,
                topLeft = Offset(centerX - radius, centerY - radius),
                size = Size(radius * 2, radius * 2)
            )
            startAngle += focusSweep
            
            // Short Break
            val shortBreakSweep = (shortBreakMinutes / total) * 360f
            drawArc(
                color = shortBreakColor,
                startAngle = startAngle,
                sweepAngle = shortBreakSweep,
                useCenter = true,
                topLeft = Offset(centerX - radius, centerY - radius),
                size = Size(radius * 2, radius * 2)
            )
            startAngle += shortBreakSweep
            
            // Long Break
            val longBreakSweep = (longBreakMinutes / total) * 360f
            drawArc(
                color = longBreakColor,
                startAngle = startAngle,
                sweepAngle = longBreakSweep,
                useCenter = true,
                topLeft = Offset(centerX - radius, centerY - radius),
                size = Size(radius * 2, radius * 2)
            )
        }
        
        // Legend
        Column(
            verticalArrangement = Arrangement.spacedBy(8.dp)
        ) {
            LegendItem(color = focusColor, label = "Focus", value = "${focusMinutes.toInt()}m")
            LegendItem(color = shortBreakColor, label = "Short Break", value = "${shortBreakMinutes.toInt()}m")
            LegendItem(color = longBreakColor, label = "Long Break", value = "${longBreakMinutes.toInt()}m")
        }
    }
}

@Composable
private fun LegendItem(color: Color, label: String, value: String) {
    Row(
        verticalAlignment = Alignment.CenterVertically,
        horizontalArrangement = Arrangement.spacedBy(12.dp)
    ) {
        Box(
            modifier = Modifier
                .size(16.dp)
                .background(color, RoundedCornerShape(4.dp))
        )
        Text(
            text = label,
            style = MaterialTheme.typography.bodyMedium,
            modifier = Modifier.weight(1f)
        )
        Text(
            text = value,
            style = MaterialTheme.typography.bodyMedium,
            fontWeight = FontWeight.SemiBold
        )
    }
}

@Preview(showBackground = true)
@Composable
private fun StatisticsScreenPreview() {
    PomodoroTheme {
        StatisticsScreen()
    }
}
