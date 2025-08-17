module ApplicationHelper
  # Check if current controller is an AI agent controller
  def agent_page?
    agent_controllers = %w[
      neochat emotisense cinegen contentcrafter memora netscope
      tradesage codemaster aiblogster datavision infoseek documind
      carebot personax authwise ideaforge vocamind taskmaster
      reportly datasphere configai labx spylens girlfriend
      callghost dnaforge dreamweaver
    ]

    agent_controllers.include?(controller_name)
  end

  # Alias for consistency with template
  def is_agent_page?
    agent_page?
  end

  # Check if we should show the footer
  def show_footer?
    !agent_page?
  end

  # Get body CSS classes for current page
  def body_css_classes
    classes = []
    classes << 'agent-page' if agent_page?
    classes << "#{controller_name}-page" if controller_name.present?
    classes.join(' ')
  end
end
