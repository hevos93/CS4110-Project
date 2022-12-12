#include "platform.h"
#include "xmerge_sort.h"
#include "xil_printf.h"

int main()
{
    print("\n\rMERGE_SORT Filter\n\r>");

    XMerge_sort merge_sort =
    {
        .Control_BaseAddress = XPAR_MERGE_SORT_0_S_AXI_CONTROL_BASEADDR,
        .IsReady = 0
    };

    init_platform();

    XMerge_sort_Config* const config = XMerge_sort_LookupConfig(XPAR_MERGE_SORT_0_DEVICE_ID);
    const int ret = XMerge_sort_CfgInitialize( &merge_sort, config);
    Xil_AssertNonvoid( ret == XST_SUCCESS );

    XMerge_sort_DisableAutoRestart(&merge_sort);

    int offset = 0;

    while(1)
    {

        if(!XMerge_sort_IsIdle(&merge_sort))
        {
        	continue;
        }

		char c = inbyte();

		if(c != '\n' && c != '\r')
		{
			XMerge_sort_Write_input_r_Bytes(&merge_sort, offset, &c, 1);
			offset++;
		}
		if(offset < 8)
		{
			continue;
		}

		XMerge_sort_Start(&merge_sort);

		while(!XMerge_sort_IsDone(&merge_sort));

		char output[8];
		XMerge_sort_Read_output_r_Bytes(&merge_sort, 0, output, 8);

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
