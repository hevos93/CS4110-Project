#include "platform.h"
#include "xbitonic_sort.h"
#include "xil_printf.h"

int main()
{
    print("\n\rBITONIC_SORT Filter\n\r>");

    XBitonic_sort bitonic_sort =
    {
        .Control_BaseAddress = XPAR_BITONIC_SORT_0_S_AXI_CONTROL_BASEADDR,
        .IsReady = 0
    };

    init_platform();

    XBitonic_sort_Config* const config = XBitonic_sort_LookupConfig(XPAR_BITONIC_SORT_0_DEVICE_ID);
    const int ret = XBitonic_sort_CfgInitialize( &bitonic_sort, config);
    Xil_AssertNonvoid( ret == XST_SUCCESS );

    XBitonic_sort_DisableAutoRestart(&bitonic_sort);

    int offset = 0;

    while(1)
    {

        if(!XBitonic_sort_IsIdle(&bitonic_sort))
        {
        	continue;
        }

		char c = inbyte();

		if(c != '\n' && c != '\r')
		{
			XBitonic_sort_Write_data_in_Bytes(&bitonic_sort, offset, &c, 1);
			offset++;
		}
		if(offset < 8)
		{
			continue;
		}

		XBitonic_sort_Start(&bitonic_sort);

		while(!XBitonic_sort_IsDone(&bitonic_sort));

		char output[8];
		XBitonic_sort_Read_data_out_Bytes(&bitonic_sort, 0, output, 8);

		for(int i = 0; i < 8; i++)
		{
			outbyte(output[i]);
		}
		outbyte('\n');

		offset = 0;
    }

    cleanup_platform();
    return 0;
}
