from __future__ import annotations
from typing import TYPE_CHECKING
from ansiblelint.rules import AnsibleLintRule

if TYPE_CHECKING:
    from ansiblelint.file_utils import Lintable
    from ansiblelint.utils import Task

class UseIncludeTasksRule(AnsibleLintRule):
    """Avoid using import_tasks, use include_tasks instead to prevent static module parsing issues on platforms without dependency collections."""
    id = "use-include-tasks"
    description = "Use include_tasks instead of import_tasks to allow dynamic evaluation and skip loading platform-specific files on incompatible hosts."
    severity = "MEDIUM"
    tags = ["custom", "task"]
    version_added = "1.0.0"
    version_changed = "1.0.0"

    def matchtask(self, task: Task, file: Lintable | None = None) -> bool | str:
        # task is an instance of ansiblelint.utils.Task
        normalized_task = getattr(task, "normalized_task", {})
        action = normalized_task.get("action", {})
        module = action.get("__ansible_module__")
        if module in ["import_tasks", "ansible.builtin.import_tasks"]:
            return "Avoid using import_tasks, use include_tasks instead to prevent static module parsing issues on platforms without dependency collections."
        return False
