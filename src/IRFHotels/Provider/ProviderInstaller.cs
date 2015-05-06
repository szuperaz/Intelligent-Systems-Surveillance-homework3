using System;
using System.Collections.Generic;
using System.Linq;
using System.Management.Instrumentation;
using System.Text;
using System.Threading.Tasks;

namespace IRFHotels.Provider
{
    // Creates and registrates MOF file
    [System.ComponentModel.RunInstaller(true)]
    public class TheInstaller : DefaultManagementInstaller { }
}
