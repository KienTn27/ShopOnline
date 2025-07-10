
        $(document).ready(function() {
            
            
            
            
            
            // Initialize DataTable
            $('#productsTable').DataTable({
                "language": {
                    "url": "//cdn.datatables.net/plug-ins/1.13.6/i18n/vi.json"
                },
                "pageLength": 10,
                "order": [[0, "desc"]],
                "columnDefs": [
                    { "orderable": false, "targets": [1, 8] }
                ]
            });
            
            // Search functionality
            $('#searchInput').on('keyup', function() {
                $('#productsTable').DataTable().search(this.value).draw();
            });
        });
        
        // Show loading
        function showLoading() {
            $('#loadingOverlay').show();
            $('#loadingSpinner').show();
        }
        
        // Hide loading
        function hideLoading() {
            $('#loadingOverlay').hide();
            $('#loadingSpinner').hide();
        }
        
        // Refresh data
        function refreshData() {
            showLoading();
            window.location.reload();
        }
        
        // Filter products
        function filterProducts() {
            const searchTerm = $('#searchInput').val();
            const categoryId = $('#categoryFilter').val();
            const priceFrom = $('#priceFrom').val();
            const priceTo = $('#priceTo').val();
            
            let url = 'ProductServlet?action=filter';
            if (searchTerm) url += '&search=' + encodeURIComponent(searchTerm);
            if (categoryId) url += '&categoryId=' + categoryId;
            if (priceFrom) url += '&priceFrom=' + priceFrom;
            if (priceTo) url += '&priceTo=' + priceTo;
            
            showLoading();
            window.location.href = url;
        }
        

        // Export to Excel
        function exportToExcel() {
            showLoading();
            
            // Get table data
            const table = document.getElementById('productsTable');
            const workbook = XLSX.utils.table_to_book(table, {sheet: "Products"});
            
            // Create filename with current date
            const now = new Date();
            const dateStr = now.getFullYear() + '-' + 
                          String(now.getMonth() + 1).padStart(2, '0') + '-' + 
                          String(now.getDate()).padStart(2, '0');
            const filename = `danh-sach-san-pham-${dateStr}.xlsx`;
            
            // Download file
            XLSX.writeFile(workbook, filename);
            
            hideLoading();
            
            // Show success message
            const toast = document.createElement('div');
            toast.className = 'toast align-items-center text-white bg-success border-0 position-fixed top-0 end-0 m-3';
            toast.style.zIndex = '9999';
            toast.innerHTML = `
                <div class="d-flex">
                    <div class="toast-body">
                        <i class="fas fa-check-circle me-2"></i>
                        Xuất Excel thành công!
                    </div>
                    <button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast"></button>
                </div>
            `;
            document.body.appendChild(toast);
            
            const bsToast = new bootstrap.Toast(toast);
            bsToast.show();
            
            // Remove toast after it's hidden
            toast.addEventListener('hidden.bs.toast', function() {
                document.body.removeChild(toast);
            });
        }
        
        // Form validation
        function validateForm(formId) {
            const form = document.getElementById(formId);
            const inputs = form.querySelectorAll('input[required], select[required]');
            let isValid = true;
            
            inputs.forEach(input => {
                if (!input.value.trim()) {
                    input.classList.add('is-invalid');
                    isValid = false;
                } else {
                    input.classList.remove('is-invalid');
                }
            });
            
            return isValid;
        }
        
        // Form submit handlers
        $('#addProductForm').on('submit', function(e) {
            if (!validateForm('addProductForm')) {
                e.preventDefault();
                alert('Vui lòng điền đầy đủ thông tin bắt buộc!');
                return false;
            }
            showLoading();
        });
        
        $('#editProductForm').on('submit', function(e) {
            if (!validateForm('editProductForm')) {
                e.preventDefault();
                alert('Vui lòng điền đầy đủ thông tin bắt buộc!');
                return false;
            }
            showLoading();
        });
        
        // Real-time search
        $('#searchInput').on('input', function() {
            const searchTerm = $(this).val().toLowerCase();
            const table = $('#productsTable').DataTable();
            table.search(searchTerm).draw();
        });
        
        // Price filter
        $('#priceFrom, #priceTo').on('change', function() {
            filterByPrice();
        });
        
        function filterByPrice() {
            const priceFrom = parseFloat($('#priceFrom').val()) || 0;
            const priceTo = parseFloat($('#priceTo').val()) || Number.MAX_VALUE;
            
            $.fn.dataTable.ext.search.push(function(settings, data, dataIndex) {
                const price = parseFloat(data[4].replace(/[^\d.-]/g, '')) || 0;
                return price >= priceFrom && price <= priceTo;
            });
            
            $('#productsTable').DataTable().draw();
            
            // Remove the filter after drawing
            $.fn.dataTable.ext.search.pop();
        }
        
        // Category filter
        $('#categoryFilter').on('change', function() {
            const categoryId = $(this).val();
            const table = $('#productsTable').DataTable();
            
            if (categoryId) {
                table.column(3).search(categoryId).draw();
            } else {
                table.column(3).search('').draw();
            }
        });
        
        // Auto-hide alerts
        setTimeout(function() {
            $('.alert').fadeOut();
        }, 5000);
        
        // Image preview for file inputs
        $('input[type="file"]').on('change', function() {
            const file = this.files[0];
            if (file) {
                const reader = new FileReader();
                reader.onload = function(e) {
                    const preview = $(this).siblings('.image-preview');
                    if (preview.length === 0) {
                        $(this).after(`
                            <div class="image-preview mt-2">
                                <img src="${e.target.result}" style="max-width: 200px; max-height: 150px; border-radius: 8px; border: 2px solid #e5e7eb;">
                            </div>
                        `);
                    } else {
                        preview.find('img').attr('src', e.target.result);
                    }
                }.bind(this);
                reader.readAsDataURL(file);
            }
        });
        
        // Keyboard shortcuts
        $(document).on('keydown', function(e) {
            // Ctrl + N: Add new product
            if (e.ctrlKey && e.key === 'n') {
                e.preventDefault();
                $('#addProductModal').modal('show');
            }
            
            // Ctrl + R: Refresh
            if (e.ctrlKey && e.key === 'r') {
                e.preventDefault();
                refreshData();
            }
            
            // Ctrl + E: Export Excel
            if (e.ctrlKey && e.key === 'e') {
                e.preventDefault();
                exportToExcel();
            }
        });
        
        // Tooltip initialization
        const tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'));
        const tooltipList = tooltipTriggerList.map(function(tooltipTriggerEl) {
            return new bootstrap.Tooltip(tooltipTriggerEl);
        });
        
        // Auto-save form data to localStorage
        function saveFormData(formId) {
            const form = document.getElementById(formId);
            const formData = new FormData(form);
            const data = {};
            
            for (let [key, value] of formData.entries()) {
                data[key] = value;
            }
            
            localStorage.setItem(formId + '_data', JSON.stringify(data));
        }
        
        function loadFormData(formId) {
            const savedData = localStorage.getItem(formId + '_data');
            if (savedData) {
                const data = JSON.parse(savedData);
                const form = document.getElementById(formId);
                
                Object.keys(data).forEach(key => {
                    const input = form.querySelector(`[name="${key}"]`);
                    if (input) {
                        if (input.type === 'checkbox') {
                            input.checked = data[key] === 'true';
                        } else {
                            input.value = data[key];
                        }
                    }
                });
            }
        }
        
        // Clear saved form data after successful submit
        function clearFormData(formId) {
            localStorage.removeItem(formId + '_data');
        }
   
   
   
   
   
