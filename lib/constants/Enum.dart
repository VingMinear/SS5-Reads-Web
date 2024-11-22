enum OrderStatus {
  pending,
  processing,
  delivering,
  completed,
  cancelled,
}

enum IconHistory {
  normal,
  cancel,
  success,
  note,
  delivered,
  payment,
}

enum ViewDetailType {
  order,
  payment,
  cancel,
}

enum ViewAs {
  grid,
  list,
}

enum UpdateProduct {
  updAll,
  updProVariant,
  updProTemplate,
}

enum ForgetBy {
  phone,
  email,
}

enum RolePermiss {
  order,
  product,
}

enum SnackBarStatus {
  success,
  error,
}

enum Network {
  connected,
  disconnected,
}

enum DisplayPosition {
  top,
  bottom,
  left,
  right,
}

enum IconType {
  image,
  svg,
}

enum InboxMessageType {
  general,
  personal,
}

enum TypeReview {
  all,
  byProduct,
}

enum ResourceType {
  product,
  order,
  promotion,
}

enum NotiType {
  product,
  order,
  promotion,
  general,
}

enum EWallet {
  history,
  payment,
}

enum EWalletStatus {
  open,
  toPay,
  pending,
  paid,
  cancel,
}
