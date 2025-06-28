struct ListView: View {
    @Query var expenseItems: [ExpenseItem]
    init(minimumCost: Double, sortOrder: [SortDescriptor<ExpenseItem>]) {
        _expenseItems = Query(filter: #Predicate<ExpenseItem>{ item in
            item.cost >= minimumCost
        }, sort: sortOrder)
    }
    var body: some View {
        List(expenseItems, id: \.self) { item in
            Text(item.name)
        }
    }
}