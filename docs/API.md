# API Documentation

## Base URL
```
https://api.yourdomain.com/v1
```

## Authentication
All requests require API key in header:
```
Authorization: Bearer <api_key>
```

---

## Merchants

### Create Merchant
```http
POST /merchants
Content-Type: application/json

{
  "businessName": "Blue Bottle Coffee",
  "abn": "12345678901",
  "contactEmail": "contact@bluebottle.com",
  "businessType": "cafe",
  "paymentConfig": {
    "payAtCounterEnabled": true,
    "qrPayEnabled": true,
    "serviceFeePercent": 2.0,
    "serviceFeeFixed": 0.0
  }
}

Response: 201 Created
{
  "id": "mer_abc123",
  "businessName": "Blue Bottle Coffee",
  "createdAt": "2025-12-16T10:00:00Z",
  ...
}
```

### Get Merchant
```http
GET /merchants/:merchant_id

Response: 200 OK
{
  "id": "mer_abc123",
  "businessName": "Blue Bottle Coffee",
  ...
}
```

---

## Products & Menu

### List Categories
```http
GET /merchants/:merchant_id/categories

Response: 200 OK
[
  {
    "id": "cat_coffee",
    "name": "Coffee",
    "sortOrder": 0
  },
  ...
]
```

### List Products
```http
GET /merchants/:merchant_id/products?categoryId=cat_coffee

Response: 200 OK
[
  {
    "id": "prod_123",
    "name": "Latte",
    "description": "Espresso with steamed milk",
    "price": 4.50,
    "categoryId": "cat_coffee",
    "modifierGroups": [
      {
        "id": "mg_size",
        "name": "Size",
        "isRequired": true,
        "minSelection": 1,
        "maxSelection": 1,
        "modifiers": [
          {
            "id": "mod_small",
            "name": "Small",
            "priceAdjustment": -0.50
          },
          {
            "id": "mod_large",
            "name": "Large",
            "priceAdjustment": 0.50
          }
        ]
      }
    ]
  }
]
```

### Create Product
```http
POST /merchants/:merchant_id/products
Content-Type: application/json

{
  "name": "Latte",
  "description": "Espresso with steamed milk",
  "price": 4.50,
  "categoryId": "cat_coffee",
  "modifierGroups": []
}

Response: 201 Created
```

### Import Products (CSV)
```http
POST /merchants/:merchant_id/products/import
Content-Type: multipart/form-data

file: products.csv

Response: 200 OK
{
  "imported": 25,
  "failed": 0
}
```

---

## Orders

### Create Order
```http
POST /orders
Content-Type: application/json

{
  "merchantId": "mer_abc123",
  "deviceId": "kiosk_001",
  "items": [
    {
      "productId": "prod_123",
      "quantity": 2,
      "unitPrice": 4.50,
      "selectedModifiers": [
        {
          "modifierGroupId": "mg_size",
          "modifierId": "mod_large"
        }
      ]
    }
  ],
  "subtotal": 10.00,
  "serviceFee": 0.20,
  "total": 10.20,
  "paymentMethod": "qrCode"
}

Response: 201 Created
{
  "id": "ord_xyz789",
  "merchantId": "mer_abc123",
  "status": "pending",
  "createdAt": "2025-12-16T10:30:00Z",
  ...
}
```

### Get Order
```http
GET /orders/:order_id

Response: 200 OK
```

### Update Order Status
```http
PATCH /orders/:order_id/status
Content-Type: application/json

{
  "status": "completed"
}

Response: 200 OK
```

---

## Payment Sessions

### Create Payment Session
```http
POST /payment-sessions
Content-Type: application/json

{
  "orderId": "ord_xyz789",
  "merchantId": "mer_abc123",
  "amountItems": 10.00,
  "feeAmount": 0.20,
  "amountTotal": 10.20
}

Response: 201 Created
{
  "id": "ps_qwe456",
  "orderId": "ord_xyz789",
  "status": "created",
  "expiresAt": "2025-12-16T10:45:00Z",
  "checkoutUrl": "https://pay.yourdomain.com/s/ps_qwe456",
  ...
}
```

### Get Payment Session
```http
GET /payment-sessions/:session_id

Response: 200 OK
{
  "id": "ps_qwe456",
  "status": "paid",
  "paidAt": "2025-12-16T10:32:00Z",
  ...
}
```

### Update Payment Session Status
```http
PATCH /payment-sessions/:session_id/status
Content-Type: application/json

{
  "status": "paid",
  "paymentIntentId": "pi_stripe123"
}

Response: 200 OK
```

---

## Webhooks

### Payment Completed
Sent from web checkout to backend when payment succeeds.

```http
POST /webhooks/payment
Content-Type: application/json
X-Webhook-Signature: <hmac_signature>

{
  "event": "payment.completed",
  "sessionId": "ps_qwe456",
  "orderId": "ord_xyz789",
  "amount": 10.20,
  "paymentIntentId": "pi_stripe123",
  "timestamp": "2025-12-16T10:32:00Z"
}

Response: 200 OK
```

Backend should:
1. Verify webhook signature
2. Update `PaymentSession` status to `paid`
3. Update `Order` status to `completed`
4. Optionally notify kiosk via WebSocket

---

## Templates

### List Templates
```http
GET /templates

Response: 200 OK
[
  {
    "id": "tpl_minimal",
    "name": "Minimal Grid",
    "description": "Clean grid layout",
    "layoutConfig": { ... }
  }
]
```

---

## Error Responses

### 400 Bad Request
```json
{
  "error": "validation_error",
  "message": "Invalid email format",
  "fields": {
    "contactEmail": "Must be valid email"
  }
}
```

### 401 Unauthorized
```json
{
  "error": "unauthorized",
  "message": "Invalid API key"
}
```

### 404 Not Found
```json
{
  "error": "not_found",
  "message": "Merchant not found"
}
```

### 500 Internal Server Error
```json
{
  "error": "internal_error",
  "message": "An unexpected error occurred"
}
```

---

## Rate Limiting

- **Rate**: 100 requests per minute per API key
- **Headers**:
  ```
  X-RateLimit-Limit: 100
  X-RateLimit-Remaining: 95
  X-RateLimit-Reset: 1734348000
  ```

---

## Data Models

### Merchant
```typescript
{
  id: string;
  businessName: string;
  abn?: string;
  contactEmail: string;
  businessType: 'cafe' | 'restaurant' | 'retail' | 'clinic' | 'other';
  createdAt: string; // ISO 8601
  isActive: boolean;
  paymentConfig: {
    payAtCounterEnabled: boolean;
    qrPayEnabled: boolean;
    serviceFeePercent: number; // 0-100
    serviceFeeFixed: number;
  };
}
```

### Product
```typescript
{
  id: string;
  name: string;
  description: string;
  price: number;
  categoryId: string;
  imageUrl?: string;
  modifierGroups: ModifierGroup[];
  isAvailable: boolean;
  isFeatured: boolean;
}
```

### Order
```typescript
{
  id: string;
  merchantId: string;
  deviceId?: string;
  items: OrderItem[];
  subtotal: number;
  serviceFee: number;
  total: number;
  status: 'draft' | 'pending' | 'confirmed' | 'completed' | 'cancelled';
  paymentMethod: 'payAtCounter' | 'qrCode';
  paymentSessionId?: string;
  createdAt: string;
  completedAt?: string;
}
```

### PaymentSession
```typescript
{
  id: string;
  orderId: string;
  merchantId: string;
  amountItems: number;
  feeAmount: number;
  amountTotal: number;
  status: 'created' | 'pending' | 'paid' | 'expired' | 'cancelled';
  createdAt: string;
  expiresAt: string;
  paidAt?: string;
  paymentIntentId?: string;
  checkoutUrl: string;
}
```
