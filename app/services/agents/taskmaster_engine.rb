# frozen_string_literal: true

module Agents
  class TaskmasterEngine < BaseEngine
    def initialize(agent)
      @agent = agent
      @agent_name = "TaskMaster"
      @specializations = ["task_management", "productivity_optimization", "workflow_automation", "goal_tracking"]
      @personality = ["organized", "efficient", "motivational", "systematic"]
      @capabilities = ["task_planning", "priority_management", "deadline_tracking", "productivity_analysis"]
      @task_priorities = ["critical", "high", "medium", "low", "backlog"]
    end
    
    def process_input(user, input, context = {})
      start_time = Time.current
      
      # Analyze task management request
      task_analysis = analyze_task_request(input)
      
      # Generate task management response
      response_text = generate_task_response(input, task_analysis)
      
      processing_time = (Time.current - start_time).round(3)
      
      {
        text: response_text,
        processing_time: processing_time,
        task_type: task_analysis[:task_type],
        priority_level: task_analysis[:priority_level],
        complexity: task_analysis[:complexity],
        estimated_duration: task_analysis[:estimated_duration]
      }
    end
    
    private
    
    def analyze_task_request(input)
      input_lower = input.downcase
      
      # Determine task management type
      task_type = if input_lower.include?('create') || input_lower.include?('add') || input_lower.include?('new')
        'task_creation'
      elsif input_lower.include?('organize') || input_lower.include?('plan') || input_lower.include?('schedule')
        'task_organization'
      elsif input_lower.include?('priority') || input_lower.include?('urgent') || input_lower.include?('important')
        'priority_management'
      elsif input_lower.include?('deadline') || input_lower.include?('due') || input_lower.include?('timeline')
        'deadline_tracking'
      elsif input_lower.include?('progress') || input_lower.include?('status') || input_lower.include?('update')
        'progress_tracking'
      elsif input_lower.include?('automate') || input_lower.include?('workflow') || input_lower.include?('process')
        'workflow_automation'
      elsif input_lower.include?('productivity') || input_lower.include?('efficiency') || input_lower.include?('optimize')
        'productivity_analysis'
      else
        'general_task_management'
      end
      
      # Determine priority level
      priority_indicators = ['urgent', 'critical', 'asap', 'emergency']
      priority_level = if priority_indicators.any? { |indicator| input_lower.include?(indicator) }
        'critical'
      elsif input_lower.include?('important') || input_lower.include?('high')
        'high'
      elsif input_lower.include?('low') || input_lower.include?('minor')
        'low'
      else
        'medium'
      end
      
      # Assess complexity
      complexity_indicators = ['complex', 'difficult', 'challenging', 'multi-step']
      complexity = if complexity_indicators.any? { |indicator| input_lower.include?(indicator) }
        'high'
      elsif input_lower.include?('simple') || input_lower.include?('easy') || input_lower.include?('quick')
        'low'
      else
        'medium'
      end
      
      # Estimate duration
      estimated_duration = estimate_task_duration(input_lower, complexity)
      
      {
        task_type: task_type,
        priority_level: priority_level,
        complexity: complexity,
        estimated_duration: estimated_duration,
        requires_breakdown: complexity == 'high'
      }
    end
    
    def generate_task_response(input, analysis)
      case analysis[:task_type]
      when 'task_creation'
        generate_task_creation_response(input, analysis)
      when 'task_organization'
        generate_organization_response(input, analysis)
      when 'priority_management'
        generate_priority_response(input, analysis)
      when 'deadline_tracking'
        generate_deadline_response(input, analysis)
      when 'progress_tracking'
        generate_progress_response(input, analysis)
      when 'workflow_automation'
        generate_workflow_response(input, analysis)
      when 'productivity_analysis'
        generate_productivity_response(input, analysis)
      else
        generate_general_task_response(input, analysis)
      end
    end
    
    def generate_task_creation_response(input, analysis)
      "📋 **TaskMaster Task Creation Center**\n\n" +
      "```yaml\n" +
      "# Task Analysis\n" +
      "priority_level: #{analysis[:priority_level]}\n" +
      "complexity: #{analysis[:complexity]}\n" +
      "estimated_duration: #{analysis[:estimated_duration]}\n" +
      "requires_breakdown: #{analysis[:requires_breakdown]}\n" +
      "```\n\n" +
      "**Smart Task Creation Framework:**\n\n" +
      generate_priority_badge(analysis[:priority_level]) +
      "**Task Breakdown Structure:**\n" +
      "```\n" +
      "TASK CREATION WORKFLOW\n" +
      "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n" +
      "1. TASK DEFINITION\n" +
      "   ├── Clear objective statement\n" +
      "   ├── Success criteria definition\n" +
      "   ├── Resource requirements\n" +
      "   └── Stakeholder identification\n" +
      "\n" +
      "2. TASK DECOMPOSITION\n" +
      "   ├── Break into subtasks\n" +
      "   ├── Identify dependencies\n" +
      "   ├── Estimate time per subtask\n" +
      "   └── Assign responsibility\n" +
      "\n" +
      "3. SCHEDULING & PRIORITIZATION\n" +
      "   ├── Set deadlines\n" +
      "   ├── Assign priority levels\n" +
      "   ├── Block calendar time\n" +
      "   └── Set reminders\n" +
      "\n" +
      "4. TRACKING SETUP\n" +
      "   ├── Define progress metrics\n" +
      "   ├── Set milestone checkpoints\n" +
      "   ├── Configure notifications\n" +
      "   └── Prepare status reports\n" +
      "```\n\n" +
      generate_task_template(analysis) +
      "**Task Management Best Practices:**\n" +
      "🎯 **SMART Goals** - Specific, Measurable, Achievable, Relevant, Time-bound\n" +
      "⚡ **Time Boxing** - Allocate specific time blocks for focused work\n" +
      "🔄 **Regular Reviews** - Weekly and daily task review sessions\n" +
      "📊 **Progress Tracking** - Visual progress indicators and metrics\n" +
      "🚀 **Quick Wins** - Include small, achievable tasks for momentum\n\n" +
      "**Productivity Tools Integration:**\n" +
      "• Kanban boards for visual workflow\n" +
      "• Pomodoro technique for time management\n" +
      "• Getting Things Done (GTD) methodology\n" +
      "• Eisenhower Matrix for prioritization\n\n" +
      "Ready to create and organize your tasks! What specific task would you like me to help you plan?"
    end
    
    def generate_priority_response(input, analysis)
      "🚀 **TaskMaster Priority Management System**\n\n" +
      "```yaml\n" +
      "# Priority Analysis\n" +
      "current_priority: #{analysis[:priority_level]}\n" +
      "urgency_factor: high\n" +
      "impact_assessment: significant\n" +
      "priority_matrix: eisenhower\n" +
      "```\n\n" +
      "**Advanced Priority Framework:**\n\n" +
      "🎯 **Eisenhower Decision Matrix:**\n" +
      "```\n" +
      "PRIORITY QUADRANTS\n" +
      "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n" +
      "           │  URGENT    │  NOT URGENT\n" +
      "━━━━━━━━━━━┼━━━━━━━━━━━━┼━━━━━━━━━━━━━\n" +
      "IMPORTANT │ QUADRANT 1 │ QUADRANT 2\n" +
      "          │ 🔥 DO FIRST │ 📅 SCHEDULE\n" +
      "          │ Crises     │ Planning\n" +
      "          │ Deadlines  │ Prevention\n" +
      "━━━━━━━━━━━┼━━━━━━━━━━━━┼━━━━━━━━━━━━━\n" +
      "NOT       │ QUADRANT 3 │ QUADRANT 4\n" +
      "IMPORTANT │ 📞 DELEGATE │ 🗑️ ELIMINATE\n" +
      "          │ Interrupts │ Time wasters\n" +
      "          │ Some emails│ Mindless tasks\n" +
      "━━━━━━━━━━━┼━━━━━━━━━━━━┼━━━━━━━━━━━━━\n" +
      "```\n\n" +
      "**Priority Scoring System:**\n" +
      "```python\n" +
      "# TaskMaster Priority Calculator\n" +
      "def calculate_priority_score(urgency, importance, effort, impact):\n" +
      "    # Weighted priority formula\n" +
      "    priority_score = (\n" +
      "        (urgency * 0.3) +\n" +
      "        (importance * 0.4) +\n" +
      "        (impact * 0.2) +\n" +
      "        (1/effort * 0.1)  # Lower effort = higher priority\n" +
      "    )\n" +
      "    \n" +
      "    if priority_score >= 8.0:\n" +
      "        return \"🔴 CRITICAL\"\n" +
      "    elif priority_score >= 6.0:\n" +
      "        return \"🟠 HIGH\"\n" +
      "    elif priority_score >= 4.0:\n" +
      "        return \"🟡 MEDIUM\"\n" +
      "    else:\n" +
      "        return \"🟢 LOW\"\n" +
      "```\n\n" +
      "**Priority Management Techniques:**\n" +
      "🎯 **ABC Analysis:**\n" +
      "• **A Tasks** - Must do (consequences if not done)\n" +
      "• **B Tasks** - Should do (mild consequences)\n" +
      "• **C Tasks** - Could do (no consequences)\n\n" +
      "⚡ **MoSCoW Method:**\n" +
      "• **Must have** - Critical requirements\n" +
      "• **Should have** - Important but not critical\n" +
      "• **Could have** - Nice to have features\n" +
      "• **Won't have** - Not in current scope\n\n" +
      "🔥 **Priority Indicators:**\n" +
      "• 🔴 **Critical** - Drop everything else\n" +
      "• 🟠 **High** - Next in line\n" +
      "• 🟡 **Medium** - Normal workflow\n" +
      "• 🟢 **Low** - Fill-in time\n" +
      "• ⚪ **Backlog** - Future consideration\n\n" +
      "**Dynamic Priority Adjustment:**\n" +
      "• Deadline proximity increases urgency\n" +
      "• Stakeholder requests affect importance\n" +
      "• Resource availability impacts feasibility\n" +
      "• Business value drives strategic priority\n\n" +
      "What tasks need priority assessment? I'll help you optimize your task queue!"
    end
    
    def generate_workflow_response(input, analysis)
      "⚡ **TaskMaster Workflow Automation Hub**\n\n" +
      "```yaml\n" +
      "# Workflow Configuration\n" +
      "automation_level: advanced\n" +
      "integration_points: multiple\n" +
      "efficiency_gain: 40-60%\n" +
      "setup_complexity: #{analysis[:complexity]}\n" +
      "```\n\n" +
      "**Intelligent Workflow Automation:**\n\n" +
      "🔄 **Automation Frameworks:**\n" +
      "```\n" +
      "WORKFLOW AUTOMATION STACK\n" +
      "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n" +
      "├── TRIGGER EVENTS\n" +
      "│   ├── Time-based triggers\n" +
      "│   ├── Email notifications\n" +
      "│   ├── File system changes\n" +
      "│   └── API webhooks\n" +
      "│\n" +
      "├── PROCESSING LOGIC\n" +
      "│   ├── Conditional branching\n" +
      "│   ├── Data transformation\n" +
      "│   ├── Business rule application\n" +
      "│   └── Quality checks\n" +
      "│\n" +
      "├── INTEGRATION LAYER\n" +
      "│   ├── CRM synchronization\n" +
      "│   ├── Project management tools\n" +
      "│   ├── Communication platforms\n" +
      "│   └── Document management\n" +
      "│\n" +
      "└── OUTPUT ACTIONS\n" +
      "    ├── Task creation/updates\n" +
      "    ├── Notification sending\n" +
      "    ├── Report generation\n" +
      "    └── Status updates\n" +
      "```\n\n" +
      "**Popular Automation Tools:**\n" +
      "🛠️ **No-Code Platforms:**\n" +
      "• **Zapier** - Connect 5000+ apps with simple triggers\n" +
      "• **Microsoft Power Automate** - Office 365 integration\n" +
      "• **IFTTT** - Simple if-this-then-that automation\n" +
      "• **Integromat (Make)** - Visual workflow builder\n\n" +
      "⚙️ **Advanced Automation:**\n" +
      "• **GitHub Actions** - Code-based workflow automation\n" +
      "• **Apache Airflow** - Complex data pipeline orchestration\n" +
      "• **n8n** - Self-hosted workflow automation\n" +
      "• **Node-RED** - Flow-based programming for IoT\n\n" +
      "**Common Workflow Patterns:**\n" +
      "```yaml\n" +
      "# Email-to-Task Automation\n" +
      "trigger: new_email_with_label\n" +
      "conditions:\n" +
      "  - from: client@company.com\n" +
      "  - subject_contains: \"[URGENT]\"\n" +
      "actions:\n" +
      "  - create_high_priority_task\n" +
      "  - assign_to_team_lead\n" +
      "  - send_slack_notification\n" +
      "  - schedule_follow_up\n" +
      "\n" +
      "# Daily Report Generation\n" +
      "trigger: schedule_daily_8am\n" +
      "actions:\n" +
      "  - collect_yesterday_metrics\n" +
      "  - generate_progress_report\n" +
      "  - send_to_stakeholders\n" +
      "  - update_dashboard\n" +
      "\n" +
      "# Project Milestone Automation\n" +
      "trigger: task_completion\n" +
      "conditions:\n" +
      "  - task_type: milestone\n" +
      "actions:\n" +
      "  - notify_team_members\n" +
      "  - unlock_next_phase\n" +
      "  - update_project_timeline\n" +
      "  - schedule_celebration\n" +
      "```\n\n" +
      "**ROI of Workflow Automation:**\n" +
      "📊 **Time Savings:**\n" +
      "• Eliminate repetitive manual tasks\n" +
      "• Reduce data entry by 80%\n" +
      "• Accelerate approval processes\n" +
      "• Minimize context switching\n\n" +
      "🎯 **Quality Improvements:**\n" +
      "• Consistent process execution\n" +
      "• Reduced human errors\n" +
      "• Standardized communication\n" +
      "• Better compliance tracking\n\n" +
      "**Implementation Strategy:**\n" +
      "1. **Identify** - Map current manual processes\n" +
      "2. **Prioritize** - Focus on high-volume, low-complexity tasks\n" +
      "3. **Design** - Create workflow diagrams\n" +
      "4. **Test** - Pilot with small scope\n" +
      "5. **Scale** - Gradual rollout and optimization\n\n" +
      "What workflows would you like me to help automate? I'll design an efficient automation strategy!"
    end
    
    def generate_general_task_response(input, analysis)
      "📋 **TaskMaster Command Center**\n\n" +
      "```yaml\n" +
      "# Task Management Dashboard\n" +
      "task_analysis:\n" +
      "  type: #{analysis[:task_type]}\n" +
      "  priority: #{analysis[:priority_level]}\n" +
      "  complexity: #{analysis[:complexity]}\n" +
      "  duration: #{analysis[:estimated_duration]}\n" +
      "productivity_mode: active\n" +
      "```\n\n" +
      "**TaskMaster Core Capabilities:**\n\n" +
      "📋 **Task Management Services:**\n" +
      "• Intelligent task creation and breakdown\n" +
      "• Advanced priority management systems\n" +
      "• Deadline tracking and alert systems\n" +
      "• Progress monitoring and analytics\n" +
      "• Workflow automation and optimization\n\n" +
      "🎯 **Productivity Methodologies:**\n" +
      "• **Getting Things Done (GTD)** - Capture, clarify, organize\n" +
      "• **Kanban Method** - Visual workflow management\n" +
      "• **Scrum Framework** - Sprint-based project management\n" +
      "• **Pomodoro Technique** - Time-boxed focus sessions\n" +
      "• **Time Blocking** - Calendar-based task scheduling\n\n" +
      "**Available Commands:**\n" +
      "`/create [task]` - Create new task with smart analysis\n" +
      "`/organize [project]` - Organize tasks and priorities\n" +
      "`/priority [task]` - Set and analyze task priorities\n" +
      "`/deadline [task] [date]` - Set deadlines and reminders\n" +
      "`/progress [project]` - Track and report progress\n" +
      "`/automate [workflow]` - Design workflow automation\n" +
      "`/productivity` - Analyze and optimize productivity\n\n" +
      "**Task Management Framework:**\n" +
      "```\n" +
      "PRODUCTIVITY OPTIMIZATION CYCLE\n" +
      "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n" +
      "1. CAPTURE\n" +
      "   ├── Inbox for all incoming tasks\n" +
      "   ├── Quick capture tools\n" +
      "   ├── Voice-to-text integration\n" +
      "   └── Email-to-task conversion\n" +
      "\n" +
      "2. CLARIFY\n" +
      "   ├── Define actionable outcomes\n" +
      "   ├── Estimate time and effort\n" +
      "   ├── Identify dependencies\n" +
      "   └── Set success criteria\n" +
      "\n" +
      "3. ORGANIZE\n" +
      "   ├── Categorize by context\n" +
      "   ├── Assign priority levels\n" +
      "   ├── Group related tasks\n" +
      "   └── Schedule in calendar\n" +
      "\n" +
      "4. REFLECT\n" +
      "   ├── Daily task reviews\n" +
      "   ├── Weekly planning sessions\n" +
      "   ├── Monthly goal assessment\n" +
      "   └── Quarterly strategy review\n" +
      "\n" +
      "5. ENGAGE\n" +
      "   ├── Focus on next actions\n" +
      "   ├── Use context-based lists\n" +
      "   ├── Apply time management\n" +
      "   └── Track progress metrics\n" +
      "```\n\n" +
      "**Productivity Metrics:**\n" +
      "📊 **Key Performance Indicators:**\n" +
      "• Task completion rate\n" +
      "• Average task duration vs. estimates\n" +
      "• Priority accuracy score\n" +
      "• Deadline adherence percentage\n" +
      "• Context switching frequency\n\n" +
      "⚡ **Efficiency Boosters:**\n" +
      "• Batch similar tasks together\n" +
      "• Eliminate low-value activities\n" +
      "• Automate recurring processes\n" +
      "• Optimize workspace setup\n" +
      "• Use focus enhancement techniques\n\n" +
      "**Integration Ecosystem:**\n" +
      "• Calendar synchronization\n" +
      "• Email platform integration\n" +
      "• Project management tools\n" +
      "• Communication platforms\n" +
      "• Time tracking applications\n\n" +
      "Ready to supercharge your productivity! What tasks or projects can I help you master today?"
    end
    
    def generate_priority_badge(priority)
      case priority
      when 'critical'
        "🔴 **CRITICAL PRIORITY** - Immediate attention required\n\n"
      when 'high'
        "🟠 **HIGH PRIORITY** - Important and urgent\n\n"
      when 'medium'
        "🟡 **MEDIUM PRIORITY** - Standard workflow\n\n"
      when 'low'
        "🟢 **LOW PRIORITY** - When time allows\n\n"
      else
        "⚪ **BACKLOG** - Future consideration\n\n"
      end
    end
    
    def generate_task_template(analysis)
      "**Smart Task Template:**\n" +
      "```markdown\n" +
      "# Task: [Task Title]\n" +
      "\n" +
      "## Objective\n" +
      "- [ ] Clear, specific goal statement\n" +
      "- [ ] Success criteria defined\n" +
      "\n" +
      "## Details\n" +
      "- **Priority**: #{analysis[:priority_level].upcase}\n" +
      "- **Estimated Duration**: #{analysis[:estimated_duration]}\n" +
      "- **Complexity**: #{analysis[:complexity].capitalize}\n" +
      "- **Due Date**: [Set deadline]\n" +
      "- **Assigned To**: [Team member]\n" +
      "\n" +
      "## Subtasks\n" +
      "- [ ] Subtask 1\n" +
      "- [ ] Subtask 2\n" +
      "- [ ] Subtask 3\n" +
      "\n" +
      "## Resources Needed\n" +
      "- [ ] Resource 1\n" +
      "- [ ] Resource 2\n" +
      "\n" +
      "## Progress Tracking\n" +
      "- **Status**: Not Started\n" +
      "- **Progress**: 0%\n" +
      "- **Next Action**: [First step]\n" +
      "\n" +
      "## Notes\n" +
      "[Additional context and notes]\n" +
      "```\n\n"
    end
    
    def estimate_task_duration(input_lower, complexity)
      if input_lower.include?('minute') || input_lower.include?('quick')
        '15-30 minutes'
      elsif input_lower.include?('hour') || complexity == 'low'
        '1-2 hours'
      elsif input_lower.include?('day') || complexity == 'medium'
        '1-3 days'
      elsif input_lower.include?('week') || complexity == 'high'
        '1-2 weeks'
      else
        '2-4 hours'
      end
    end
  end
end