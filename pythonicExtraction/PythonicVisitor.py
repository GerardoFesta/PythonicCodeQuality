import ast

class PythonicVisitor(ast.NodeVisitor):
    def __init__(self):
        self.pythonic_dict = {
            'PY_Assign Multi Targets': 0,
            'PY_Call Star': 0,
            'PY_List Comprehension': 0,
            'PY_Dict Comprehension': 0,
            'PY_Set Comprehension': 0,
            'PY_Truth Value Test': 0,
            'PY_Chain Compare': 0,
            'PY_For Multi Targets': 0,
            'PY_For Else': 0
        }

    def visit_Assign(self, node):
        if len(node.targets) > 1:
            self.pythonic_dict['PY_Assign Multi Targets'] += 1
        self.generic_visit(node)

    def visit_Call(self, node):
        for expr in node.args:
            if isinstance(expr, ast.Starred):
                self.pythonic_dict['PY_Call Star'] += 1
        self.generic_visit(node)

    def visit_ListComp(self, node):
        self.pythonic_dict['PY_List Comprehension'] += 1
        self.generic_visit(node)

    def visit_DictComp(self, node):
        self.pythonic_dict['PY_Dict Comprehension'] += 1
        self.generic_visit(node)

    def visit_SetComp(self, node):
        self.pythonic_dict['PY_Set Comprehension'] += 1
        self.generic_visit(node)

    def visit_If(self, node):
        if not isinstance(node.test, ast.Compare):
            self.pythonic_dict['PY_Truth Value Test'] += 1
        self.generic_visit(node)

    def visit_Compare(self, node):
        if len(node.ops) > 1:
            self.pythonic_dict['PY_Chain Compare'] += 1
        self.generic_visit(node)

    def visit_For(self, node):
        if isinstance(node.target, ast.List):
            self.pythonic_dict['PY_For Multi Targets'] += 1
        if node.orelse:
            self.pythonic_dict['PY_For Else'] += 1
        self.generic_visit(node)

    def get_pythonic_metrics(self):
        return self.pythonic_dict
