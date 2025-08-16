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

  # Check if we should show the footer
  def show_footer?
    !agent_page?
  end
end
