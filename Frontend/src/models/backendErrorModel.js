import { useState } from "react"
export function BackendErrorModel() {
    // Shows the error in modal error
    const [backendError, setBackendError] = useState({
        ErrorCode: "",
        ErrorDetail: ""
    });

    return [backendError, setBackendError]
}